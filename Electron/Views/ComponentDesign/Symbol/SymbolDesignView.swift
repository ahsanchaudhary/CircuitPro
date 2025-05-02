import SwiftUI

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  

  var body: some View {
      @Bindable var manager = componentDesignManager
    NSCanvasView {
      // Render every CanvasElement
        ForEach(Array(componentDesignManager.symbolElements.enumerated()), id: \.element.id) { idx, _ in
            CanvasElementView(
                element: $manager.symbolElements[idx],
                isSelected: componentDesignManager.symbolInteraction.selectedIDs.contains(componentDesignManager.symbolElements[idx].id),
                offset: componentDesignManager.symbolInteraction.dragManager.dragOffset(for: componentDesignManager.symbolElements[idx]),
                alpha: componentDesignManager.symbolInteraction.dragManager.dragOpacity(for: componentDesignManager.symbolElements[idx])
            )
        }
      // Preview of whatever tool is active
      if let tool = componentDesignManager.selectedTool {
          tool.preview(mousePosition: canvasManager.canvasMousePosition, context: .init(existingPinCount: componentDesignManager.allPins.count ))
      }

      // Marquee
        if let rect = componentDesignManager.symbolInteraction.marqueeRect {
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
          componentDesignManager.symbolInteraction.tap(
          at: location,
          items: componentDesignManager.symbolElements,
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
          if let e = tool.handleTap(at: loc, context: .init(existingPinCount: componentDesignManager.allPins.count - 1)) {
            withAnimation {
                componentDesignManager.symbolElements.append(e)
            }
          
        }
        componentDesignManager.selectedTool = tool
      }
    }

    // MARK: Drag → move whichever elements are selected
    .onDragContentGesture { phase, location, translation, proxy in
      let didDrag = componentDesignManager.symbolInteraction.drag(
        phase: phase,
        location: location,
        translation: translation,
        proxy: proxy,
        items: componentDesignManager.symbolElements,
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
          guard let i = componentDesignManager.symbolElements.firstIndex(where: { $0.id == elem.id })
          else { return }

          switch elem {
          case .primitive(var p):
            // p.position setter will shift start/end automatically
            p.position = CGPoint(x: newPos.x, y: newPos.y)
              componentDesignManager.symbolElements[i] = .primitive(p)

          case .pin(var pin):
            pin.position = newPos
              componentDesignManager.symbolElements[i] = .pin(pin)
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
