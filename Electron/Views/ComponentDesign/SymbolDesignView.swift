import SwiftUI

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var primitives: [GraphicPrimitiveType] = []
  @State private var interaction =
    CanvasInteractionManager<GraphicPrimitiveType, UUID>(idProvider: \.id)

  var body: some View {
    NSCanvasView {
      // Render + drag offsets + opacity
      ForEach($primitives) { $p in
        p.renderFullView(
          isSelected: interaction.selectedIDs.contains(p.id),
          binding:    $p,
          dragOffset: interaction.dragManager.dragOffset(for: p),
          opacity:    interaction.dragManager.dragOpacity(for: p)
        )
      }

      // Tool preview
      if let tool = componentDesignManager.activeGraphicsTool {
        tool.preview(mousePosition: canvasManager.canvasMousePosition)
      }

      // Marquee overlay
      if let rect = interaction.marqueeRect {
        Path { $0.addRect(rect) }
          .stroke(.blue, lineWidth: 1)
          .background(Path { $0.addRect(rect) }
            .fill(.blue.opacity(0.1)))
          .allowsHitTesting(false)
      }
    }
    // Tap → delegate to interaction
    .onTapContentGesture { location, _ in
      // are we in cursor mode?
      let isCursor = componentDesignManager.selectedSymbolDesignTool == .cursor
      let modifiers = EventModifiers(
        from: NSApp.currentEvent?.modifierFlags ?? []
      )

      if isCursor {
        //–– CURSOR: do selection only
        interaction.tap(
          at: location,
          items:    primitives,
          hitTest:  { prim, pt in
                      prim.systemHitTest(at: pt, symbolCenter: .zero)
                    },
          drawToolActive: false,         // not used for selection in this branch
          modifiers:      modifiers
        )
      } else {
        //–– DRAWING TOOL: create a new primitive
        guard var tool = componentDesignManager.activeGraphicsTool else { return }
        if let newPrim = tool.handleTap(
              at: canvasManager.canvasMousePosition
           ) {
          primitives.append(newPrim)
        }
        componentDesignManager.activeGraphicsTool = tool
      }
    }

    // Drag+Marquee → delegate to interaction
    .onDragContentGesture { phase, loc, trans, proxy in
      interaction.drag(
        phase: phase,
        location: loc,
        translation: trans,
        proxy: proxy,
        items: primitives,
        hitTest: { $0.systemHitTest(at: $1, symbolCenter: .zero, tolerance: 5) },
        positionForItem: { $0.position.asSDPoint },
        setPositionForItem: { prim, pt in
          if let i = primitives.firstIndex(where: { $0.id == prim.id }) {
            primitives[i].position = CGPoint(x: pt.x, y: pt.y)
          }
        },
        snapping: canvasManager.enableSnapping
          ? canvasManager.snap
          : { $0 }
      )
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


