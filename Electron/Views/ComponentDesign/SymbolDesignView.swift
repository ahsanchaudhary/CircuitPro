import SwiftUI



struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var primitives: [GraphicPrimitiveType] = []

  @State private var dragManager =
    CanvasDragManager<GraphicPrimitiveType, UUID>(idProvider: { $0.id })
    
    @State private var tapManager = CanvasTapManager()

  var body: some View {
    NSCanvasView {
      // — Render saved primitives
        ForEach($primitives) { $prim in
            prim.renderFullView(isSelected: tapManager.isSelected(prim.id), binding: $prim, dragOffset: dragManager.dragOffset(for: prim), opacity: dragManager.dragOpacity(for: prim))
        }




      // — Tool preview (line, rect, circle)
        if let tool = componentDesignManager.activeGraphicsTool {
        tool.preview(mousePosition: canvasManager.canvasMousePosition)
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


    // — Drag to move shapes
    .onDragContentGesture { phase, loc, trans, proxy in
        dragManager.handleDrag(
          phase: phase,
          location: loc,
          translation: trans,
          proxy: proxy,
          items: primitives,
          hitTest: { prim, pt in
            prim.systemHitTest(at: pt, symbolCenter: .zero, tolerance: 5)
          },
          positionForItem: { prim in SDPoint(prim.position) },
          setPositionForItem: { prim, final in
            if let i = primitives.firstIndex(where: { $0.id == prim.id }) {
              primitives[i].position = CGPoint(x: final.x, y: final.y)
            }
          },
          selectedIDs: tapManager.selectedIDs, // 🔥 key
          snapping: canvasManager.enableSnapping
            ? canvasManager.snap
            : { $0 }
        )

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
