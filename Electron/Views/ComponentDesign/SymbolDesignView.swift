import SwiftUI

// Define the tools for the layout toolbar.
enum SymbolDesignTools: String, CaseIterable, ToolbarTool {
    case cursor = "cursorarrow"
    case line = "line.diagonal"
    case arc = "wave.3.up"
    case rectangle = "rectangle"
    case circle = "circle"
    case polygon = "hexagon"
    
    // Conform to ToolbarTool by specifying the default cursor.
    static var defaultTool: SymbolDesignTools { .cursor }
}

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager

  @State private var dragManager =
    CanvasDragManager<GraphicPrimitiveType, UUID>(idProvider: { $0.id })

  @State private var primitives: [GraphicPrimitiveType] = [
    .circle(.init(position: CGPoint(x: 1500, y: 1500),
                  strokeWidth: 1,
                  color: .init(color: .red),
                  filled: true,
                  radius: 50))
  ]

  var body: some View {
    NSCanvasView {
      ForEach(primitives) { prim in
        prim
          .render()
          .position(prim.position)
          .offset(dragManager.dragOffset(for: prim))
          .opacity(dragManager.dragOpacity(for: prim))
      }
    }
    .onDragContentGesture { phase, loc, trans, proxy in
      dragManager.handleDrag(
        phase: phase, location: loc, translation: trans, proxy: proxy,
        items: primitives,
        hitTest: { primitive, tap in
          primitive.systemHitTest(
            at: tap,
            symbolCenter: .zero,  // direct model‑space = canvas‑space
            tolerance: 5
          )
        },
        positionForItem: { primitive in
          SDPoint(primitive.position)         // report canvas‑space
        },
        setPositionForItem: { primitive, finalSD in
          // finalSD is in canvas‑space
          if let idx = primitives.firstIndex(where:{ $0.id==primitive.id }) {
            primitives[idx].position = CGPoint(x: finalSD.x, y: finalSD.y)
          }
        },
        snapping: canvasManager.enableSnapping ? canvasManager.snap : { $0 }
      )
    }

    .clipAndStroke(with: .rect(cornerRadius: 15))
    .overlay {
        HStack {
            Spacer()
            
        }
    }
  }
}

struct SymbolDesignToolbarView: View {
    
    @Environment(\.canvasManager) private var canvasManager
   
    
    var body: some View {
        ToolbarView<SymbolDesignTools>(
            tools: SymbolDesignTools.allCases,
            // Insert a divider after the cursor and zone tools.
            dividerAfter: { tool in
                tool == .cursor
            },
            imageName: { $0.rawValue },
            onToolSelected: { tool in
                // Handle layout tool selection.
                print("Layout tool selected:", tool)
                canvasManager.selectedLayoutTool = tool
            }
        )
    }
}
