import SwiftUI

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var primitives: [GraphicPrimitiveType] = []

  @State private var dragManager =
    CanvasDragManager<GraphicPrimitiveType, UUID>(idProvider: { $0.id })
    
  @State private var tapManager = CanvasTapManager()
  
  @State private var marqueeStart: CGPoint?
  @State private var marqueeEnd: CGPoint?
    @State private var isDragging = false
    @State private var isMarqueeActive = false




  var body: some View {
    NSCanvasView {
      // — Render saved primitives
      ForEach($primitives) { $prim in
        prim.renderFullView(
          isSelected: tapManager.isSelected(prim.id),
          binding: $prim,
          dragOffset: dragManager.dragOffset(for: prim),
          opacity: dragManager.dragOpacity(for: prim)
        )
      }

      // — Tool preview (line, rect, circle)
      if let tool = componentDesignManager.activeGraphicsTool {
        tool.preview(mousePosition: canvasManager.canvasMousePosition)
      }

      // — Marquee rectangle preview
        if let start = marqueeStart, let end = marqueeEnd {
          let snappedStart = canvasManager.snap(start)
          let snappedEnd = canvasManager.snap(end)

          let rect = CGRect(
            x: min(snappedStart.x, snappedEnd.x),
            y: min(snappedStart.y, snappedEnd.y),
            width: abs(snappedEnd.x - snappedStart.x),
            height: abs(snappedEnd.y - snappedStart.y)
          )

          Path { path in
            path.addRect(rect)
          }
          .stroke(.blue, lineWidth: 1)
          .background(
            Path { path in
              path.addRect(rect)
            }
            .fill(.blue.opacity(0.1))
          )
          .allowsHitTesting(false)
        }

    }

    .onTapContentGesture { location, _ in
      let modifiers = EventModifiers(from: NSApp.currentEvent?.modifierFlags ?? [])

      if componentDesignManager.selectedSymbolDesignTool == .cursor {
        let hit = primitives.reversed().first(where: {
          $0.systemHitTest(at: location, symbolCenter: .zero)
        })

        tapManager.handleTap(on: hit?.id, modifiers: modifiers)
        return
      }

      // Tool mode → draw
      guard var tool = componentDesignManager.activeGraphicsTool else { return }
      if let newPrimitive = tool.handleTap(at: canvasManager.canvasMousePosition) {
        primitives.append(newPrimitive)
      }
      componentDesignManager.activeGraphicsTool = tool
    }

    .onDragContentGesture { phase, location, translation, proxy in
      let snapping = canvasManager.enableSnapping ? canvasManager.snap : { $0 }

      // Decide gesture ownership
      switch phase {
      case .possible:
        // Try to drag something
        let isDragTarget = dragManager.handleDrag(
          phase: .possible,
          location: location,
          translation: translation,
          proxy: proxy,
          items: primitives,
          hitTest: { prim, pt in prim.systemHitTest(at: pt, symbolCenter: .zero, tolerance: 5) },
          positionForItem: { $0.position.asSDPoint },
          setPositionForItem: { _, _ in },
          selectedIDs: tapManager.selectedIDs,
          snapping: snapping
        )

        isDragging = isDragTarget
        isMarqueeActive = !isDragTarget
        return isDragTarget || isMarqueeActive // Let SwiftUI commit the gesture

      case .began:
        if isMarqueeActive {
          marqueeStart = location
          marqueeEnd = location
          return true
        }

        // Allow drag manager to begin
        return dragManager.handleDrag(
          phase: .began,
          location: location,
          translation: translation,
          proxy: proxy,
          items: primitives.filter { tapManager.selectedIDs.contains($0.id) },
          hitTest: { prim, pt in prim.systemHitTest(at: pt, symbolCenter: .zero, tolerance: 5) },
          positionForItem: { $0.position.asSDPoint },
          setPositionForItem: { _, _ in },
          selectedIDs: tapManager.selectedIDs,
          snapping: snapping
        )

      case .changed:
        if isMarqueeActive {
          marqueeEnd = location
          return true
        }

        return dragManager.handleDrag(
          phase: .changed,
          location: location,
          translation: translation,
          proxy: proxy,
          items: primitives.filter { tapManager.selectedIDs.contains($0.id) },
          hitTest: { prim, pt in prim.systemHitTest(at: pt, symbolCenter: .zero, tolerance: 5) },
          positionForItem: { $0.position.asSDPoint },
          setPositionForItem: { _, _ in },
          selectedIDs: tapManager.selectedIDs,
          snapping: snapping
        )

      case .ended, .cancelled:
        if isMarqueeActive {
          if let start = marqueeStart, let end = marqueeEnd {
            let rect = CGRect(
              x: min(start.x, end.x),
              y: min(start.y, end.y),
              width: abs(end.x - start.x),
              height: abs(end.y - start.y)
            )

            let selected = primitives.filter {
              rect.contains($0.position)
            }

            let modifiers = EventModifiers(from: NSApp.currentEvent?.modifierFlags ?? [])
            tapManager.setSelected(selected.map(\.id), modifiers: modifiers)
          }

          marqueeStart = nil
          marqueeEnd = nil
          isMarqueeActive = false
          return true
        }

        let didEndDrag = dragManager.handleDrag(
          phase: phase,
          location: location,
          translation: translation,
          proxy: proxy,
          items: primitives.filter { tapManager.selectedIDs.contains($0.id) },
          hitTest: { prim, pt in prim.systemHitTest(at: pt, symbolCenter: .zero, tolerance: 5) },
          positionForItem: { $0.position.asSDPoint },
          setPositionForItem: { prim, final in
            if let i = primitives.firstIndex(where: { $0.id == prim.id }) {
              primitives[i].position = CGPoint(x: final.x, y: final.y)
            }
          },
          selectedIDs: tapManager.selectedIDs,
          snapping: snapping
        )

        isDragging = false
        return didEndDrag

      default:
        return false
      }
    }

    // — UI overlay (toolbar)
    .clipAndStroke(with: .rect(cornerRadius: 20))
    .overlay {
      CanvasOverlayView(enableComponentDrawer: false) {
        SymbolDesignToolbarView()
      }
      .padding(10)
    }
  }
}

extension CGPoint {
  var asSDPoint: SDPoint { SDPoint(self) }
}
