import SwiftUI

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var dragManager =
    CanvasDragManager<GraphicPrimitiveType, UUID>(idProvider: { $0.id })

  @State private var primitives: [GraphicPrimitiveType] = []

  // Tool state
  @State private var circleStart: CGPoint? = nil
  @State private var rectStart:   CGPoint? = nil
  @State private var lineStart:   CGPoint? = nil

  var body: some View {
    NSCanvasView {
      // — Render saved primitives
        ForEach(primitives) { prim in
          prim
            .render()
            .overlay {
              Text("\(Int(prim.base.position.x)), \(Int(prim.base.position.y))")
                .font(.caption2)
                .foregroundStyle(.gray)
            }
            .if(!prim.isLine) { $0.position(prim.position) } // ✅ apply only if not a line
            .offset(dragManager.dragOffset(for: prim))
            .opacity(dragManager.dragOpacity(for: prim))
        }


      // — Circle preview
      if componentDesignManager.selectedSymbolDesignTool == .circle,
         let center = circleStart {
        let current = canvasManager.canvasMousePosition
        let radius = hypot(current.x - center.x, current.y - center.y)

        Circle()
          .stroke(.blue, style: .init(lineWidth: 1, dash: [4]))
          .frame(width: radius * 2, height: radius * 2)
          .position(center)
          .allowsHitTesting(false)
      }

      // — Rectangle preview
      if componentDesignManager.selectedSymbolDesignTool == .rectangle,
         let start = rectStart {
        let current = canvasManager.canvasMousePosition
        let rect = CGRect(origin: start, size: .zero)
                      .union(CGRect(origin: current, size: .zero))

        Path { path in path.addRect(rect) }
          .stroke(.green, style: .init(lineWidth: 1, dash: [4]))
          .allowsHitTesting(false)
      }

      // — Line preview
      if componentDesignManager.selectedSymbolDesignTool == .line,
         let start = lineStart {
        let current = canvasManager.canvasMousePosition
        Path { path in
          path.move(to: start)
          path.addLine(to: current)
        }
        .stroke(.orange, style: .init(lineWidth: 1, dash: [4]))
        .allowsHitTesting(false)
      }
    }
    .onTapContentGesture { location, _ in
      switch componentDesignManager.selectedSymbolDesignTool {
      case .circle:
        if let center = circleStart {
          let r = hypot(location.x - center.x, location.y - center.y)
          let circle = GraphicPrimitiveType.circle(
            .init(position: center,
                  strokeWidth: 1,
                  color: .init(color: .blue),
                  filled: false,
                  radius: r)
          )
          primitives.append(circle)
          circleStart = nil
        } else {
          circleStart = location
        }

      case .rectangle:
        if let start = rectStart {
          let rect = CGRect(origin: start, size: .zero)
                      .union(CGRect(origin: location, size: .zero))
          let center = CGPoint(x: rect.midX, y: rect.midY)
          let rectangle = GraphicPrimitiveType.rectangle(
            .init(position: center,
                  strokeWidth: 1,
                  color: .init(color: .green),
                  filled: false,
                  size: rect.size,
                  cornerRadius: 0)
          )
          primitives.append(rectangle)
          rectStart = nil
        } else {
          rectStart = location
        }

      case .line:
        if let start = lineStart {
          let line = GraphicPrimitiveType.line(
            .init(strokeWidth: 1,
                  color: .init(color: .orange),
                  start: start,
                  end: location)
          )
          primitives.append(line)
          lineStart = nil
        } else {
          lineStart = location
        }

      default:
        break
      }
    }
    .onDragContentGesture { phase, loc, trans, proxy in
      dragManager.handleDrag(
        phase: phase,
        location: loc,
        translation: trans,
        proxy: proxy,
        items: primitives,
        hitTest: { prim, tap in
          prim.systemHitTest(at: tap, symbolCenter: .zero, tolerance: 5)
        },
        positionForItem: { prim in SDPoint(prim.position) },
        setPositionForItem: { prim, final in
          if let i = primitives.firstIndex(where: { $0.id == prim.id }) {
            primitives[i].position = CGPoint(x: final.x, y: final.y)
          }
        },
        snapping: canvasManager.enableSnapping
               ? canvasManager.snap
               : { $0 }
      )
    }
    .clipAndStroke(with: .rect(cornerRadius: 15))
    .overlay {
      HStack {
        Spacer()
        SymbolDesignToolbarView()
      }
    }
  }
}
