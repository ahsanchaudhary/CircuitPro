import SwiftUI

protocol GraphicsTool {
  associatedtype Preview: View

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType?
  
  @ViewBuilder
  func preview(mousePosition: CGPoint) -> Preview
}

enum AnyGraphicsTool {
  case line(LineTool)
  case rectangle(RectangleTool)
  case circle(CircleTool)

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    switch self {
    case .line(var tool): let result = tool.handleTap(at: location); self = .line(tool); return result
    case .rectangle(var tool): let result = tool.handleTap(at: location); self = .rectangle(tool); return result
    case .circle(var tool): let result = tool.handleTap(at: location); self = .circle(tool); return result
    }
  }

  @ViewBuilder
  func preview(mousePosition: CGPoint) -> some View {
    switch self {
    case .line(let tool): tool.preview(mousePosition: mousePosition)
    case .rectangle(let tool): tool.preview(mousePosition: mousePosition)
    case .circle(let tool): tool.preview(mousePosition: mousePosition)
    }
  }
}

struct LineTool: GraphicsTool {
  var start: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let s = start {
      let line = GraphicPrimitiveType.line(
        .init(strokeWidth: 1, color: .init(color: .orange), start: s, end: location)
      )
      start = nil
      return line
    } else {
      start = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      Group {
          if let s = start {
              Path { $0.move(to: s); $0.addLine(to: mousePosition) }
                  .stroke(.orange, style: .init(lineWidth: 1, dash: [4]))
                  .allowsHitTesting(false)
          }
      }
  }
}

import SwiftUI

struct RectangleTool: GraphicsTool {
  var start: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let s = start {
      let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: location, size: .zero))
      let center = CGPoint(x: rect.midX, y: rect.midY)
      let prim = GraphicPrimitiveType.rectangle(
        .init(
          position: center,
          strokeWidth: 1,
          color: .init(color: .green),
          filled: false,
          size: rect.size,
          cornerRadius: 0
        )
      )
      start = nil
      return prim
    } else {
      start = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      Group {
          if let s = start {
              let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: mousePosition, size: .zero))
              Path { $0.addRect(rect) }
                  .stroke(.green, style: .init(lineWidth: 1, dash: [4]))
                  .allowsHitTesting(false)
          }
    }
  }
}

import SwiftUI
import SwiftUI

struct CircleTool: GraphicsTool {
  var center: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let c = center {
      let r = hypot(location.x - c.x, location.y - c.y)
      let prim = GraphicPrimitiveType.circle(
        .init(
          position: c,
          strokeWidth: 1,
          color: .init(color: .blue),
          filled: false,
          radius: r
        )
      )
      center = nil
      return prim
    } else {
      center = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
    Group {
      if let c = center {
        let radius = hypot(mousePosition.x - c.x, mousePosition.y - c.y)

        ZStack {
          // Circle outline
          Circle()
            .stroke(.blue, style: .init(lineWidth: 1, dash: [4]))
            .frame(width: radius * 2, height: radius * 2)
            .position(c)

          // Radius line
          Path { path in
            path.move(to: c)
            path.addLine(to: mousePosition)
          }
          .stroke(.gray.opacity(0.5))

          // Radius text
          Text(String(format: "%.1f", radius))
                .font(.caption2)
            .foregroundColor(.blue)
            .directionalPadding(vertical: 2.5, horizontal: 5)
            .background(.thinMaterial)
            .clipAndStroke(with: .capsule)
            .position(x: (c.x + mousePosition.x) / 2,
                      y: (c.y + mousePosition.y) / 2 - 10)
        }
        .allowsHitTesting(false)
      }
    }
  }
}




struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var primitives: [GraphicPrimitiveType] = []

  @State private var dragManager =
    CanvasDragManager<GraphicPrimitiveType, UUID>(idProvider: { $0.id })

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
              .if(prim.isLine) { $0.position(prim.position) }
          }
          .if(!prim.isLine) { $0.position(prim.position) }
          .offset(dragManager.dragOffset(for: prim))
          .opacity(dragManager.dragOpacity(for: prim))
      }

      // — Tool preview (line, rect, circle)
        if let tool = componentDesignManager.activeGraphicsTool {
        tool.preview(mousePosition: canvasManager.canvasMousePosition)
      }
    }

    // — Tap to draw
    .onTapContentGesture { _, _ in
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
        snapping: canvasManager.enableSnapping
          ? canvasManager.snap
          : { $0 }
      )
    }

    // — UI overlay (toolbar)
    .clipAndStroke(with: .rect(cornerRadius: 15))
    .overlay {
      HStack {
        Spacer()
        SymbolDesignToolbarView()
      }
    }
  }
}
