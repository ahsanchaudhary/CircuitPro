import SwiftUI

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var elements: [CanvasElement] = []
  @State private var interaction =
    CanvasInteractionManager<CanvasElement, UUID>(idProvider: \.id)

  var body: some View {
    NSCanvasView {
      // Render every CanvasElement
        ForEach(Array(elements.enumerated()), id: \.element.id) { idx, _ in
            CanvasElementView(
                element: $elements[idx],
                isSelected: interaction.selectedIDs.contains(elements[idx].id),
                offset: interaction.dragManager.dragOffset(for: elements[idx]),
                alpha: interaction.dragManager.dragOpacity(for: elements[idx])
            )
        }
      // Preview of whatever tool is active
      if let tool = componentDesignManager.selectedTool {
        tool.preview(mousePosition: canvasManager.canvasMousePosition)
      }

      // Marquee
      if let rect = interaction.marqueeRect {
        Path { $0.addRect(rect) }
          .stroke(.blue, lineWidth: 1)
          .background(Path { $0.addRect(rect) }
            .fill(.blue.opacity(0.1)))
          .allowsHitTesting(false)
      }
    }

    // MARK: Tap → selection vs placement
    .onTapContentGesture { location, _ in
      let loc = canvasManager.canvasMousePosition
      let mods = EventModifiers(
        from: NSApp.currentEvent?.modifierFlags ?? []
      )

      if componentDesignManager.selectedTool?.id == "cursor" {
        // selection
        interaction.tap(
          at: location,
          items: elements,
          hitTest: { elem, pt in
              switch elem {
                  case .primitive(let p):
                      return p.systemHitTest(at: pt, symbolCenter: .zero)
                  case .pin(let pin):
                      return pin.systemHitTest(at: pt)
              }
          },
          drawToolActive: false,
          modifiers: mods
        )
      } else {
        // placement
        guard var tool = componentDesignManager.selectedTool else { return }
        if let e = tool.handleTap(at: loc) {
          elements.append(e)
        }
        componentDesignManager.selectedTool = tool
      }
    }

    // MARK: Drag → move whichever elements are selected
    .onDragContentGesture { phase, location, translation, proxy in
      let didDrag = interaction.drag(
        phase: phase,
        location: location,
        translation: translation,
        proxy: proxy,
        items: elements,
        hitTest: { elem, pt in
            switch elem {
                case .primitive(let p):
                    return p.systemHitTest(at: pt, symbolCenter: .zero)
                case .pin(let pin):
                    return pin.systemHitTest(at: pt)
            }
        },
        positionForItem: { elem in
          switch elem {
          case .primitive(let p):
            // use the position you’ve defined
            return SDPoint(p.position)
          case .pin(let pin):
            return pin.position
          }
        },
        setPositionForItem: { elem, newPos in
          guard let i = elements.firstIndex(where: { $0.id == elem.id })
          else { return }

          switch elem {
          case .primitive(var p):
            // p.position setter will shift start/end automatically
            p.position = CGPoint(x: newPos.x, y: newPos.y)
            elements[i] = .primitive(p)

          case .pin(var pin):
            pin.position = newPos
            elements[i] = .pin(pin)
          }
        },
        snapping: canvasManager.enableSnapping
          ? canvasManager.snap
          : { $0 }
      )

      return didDrag
    }

    .clipAndStroke(with: .rect(cornerRadius: 20))
    .overlay {
      CanvasOverlayView(enableComponentDrawer: false) {
        SymbolDesignToolbarView()
      }
      .padding(10)
    }
  }
}


struct CanvasElementView: View {
    @Binding var element: CanvasElement
    let isSelected: Bool
    let offset: CGSize
    let alpha: CGFloat

    var body: some View {
        switch element {
        case .primitive(var p):
            // We mutate via binding
            let primBinding = Binding<GraphicPrimitiveType>(
                get: { p },
                set: { newP in element = .primitive(newP) }
            )
            primBinding.wrappedValue.renderWithHandles(
                isSelected: isSelected,
                binding:    primBinding,
                dragOffset: offset,
                opacity:    alpha
            )

        case .pin(var pin):
            let pinBinding = Binding<Pin>(
                get: { pin },
                set: { newPin in element = .pin(newPin) }
            )
            PinView(
                pin: pin,
                isSelected: isSelected,
                offset: offset,
                opacity: alpha
            )
        }
    }
}
