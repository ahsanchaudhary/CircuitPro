import SwiftUI

// MARK: — Helpers

func normalizeAngle(_ angle: CGFloat) -> CGFloat {
  let mod = angle.truncatingRemainder(dividingBy: 360)
  return mod >= 0 ? mod : mod + 360
}

extension CGFloat {
  var radiansToDegrees: CGFloat { self * 180 / .pi }
  var degreesToRadians: CGFloat { self * .pi / 180 }
}

struct SymbolDesignView: View {
  @Environment(\.canvasManager) private var canvasManager
  @Environment(\.componentDesignManager) private var componentDesignManager

  @State private var dragManager =
    CanvasDragManager<GraphicPrimitiveType, UUID>(idProvider: { $0.id })

  @State private var primitives: [GraphicPrimitiveType] = []

  // Tool state
  @State private var circleStart: CGPoint? = nil
  @State private var rectStart:   CGPoint? = nil
  @State private var arcStart:    CGPoint? = nil
  @State private var arcMid:      CGPoint? = nil

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
          .position(prim.position)
          .offset(dragManager.dragOffset(for: prim))
          .opacity(dragManager.dragOpacity(for: prim))
      }

      // — Circle preview
      if componentDesignManager.selectedSymbolDesignTool == .circle,
         let center = circleStart
      {
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
         let start = rectStart
      {
        let current = canvasManager.canvasMousePosition
        let rect = CGRect(origin: start, size: .zero)
                    .union(CGRect(origin: current, size: .zero))

        Path { path in
          path.addRect(rect)
        }
        .stroke(.green, style: .init(lineWidth: 1, dash: [4]))
        .allowsHitTesting(false)
      }

      // — Arc preview (both directions & full sweep)
      if componentDesignManager.selectedSymbolDesignTool == .arc,
         let center = arcStart,
         let startPt = arcMid
      {
        Path { path in
          let current = canvasManager.canvasMousePosition
          // vectors from center
          let v1 = CGPoint(x: startPt.x - center.x, y: startPt.y - center.y)
          let v2 = CGPoint(x: current.x  - center.x, y: current.y  - center.y)
          let radius = hypot(v1.x, v1.y)

          // normalized angles
          let sDeg = normalizeAngle(atan2(v1.y, v1.x).radiansToDegrees)
          let eDeg = normalizeAngle(atan2(v2.y, v2.x).radiansToDegrees)

          // direction by cross product
          let cross = v1.x * v2.y - v1.y * v2.x
          let clockwise = cross < 0

          // sweep magnitude
          let endDeg: CGFloat
          if clockwise {
            let rawCW = normalizeAngle(sDeg - eDeg)
            endDeg = sDeg - rawCW
          } else {
            let rawCCW = normalizeAngle(eDeg - sDeg)
            endDeg = sDeg + rawCCW
          }

          path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(sDeg),
            endAngle:   .degrees(endDeg),
            clockwise:  clockwise
          )
        }
        .stroke(.orange, style: .init(lineWidth: 1, dash: [4]))
        .allowsHitTesting(false)
      }
    }
    // Tap to place shapes
    .onTapContentGesture { location, _ in
      switch componentDesignManager.selectedSymbolDesignTool {
      case .circle:
        if let center = circleStart {
          let r = hypot(location.x - center.x, location.y - center.y)
          let circle = GraphicPrimitiveType.circle(
            .init(position:    center,
                  strokeWidth: 1,
                  color:       .init(color: .blue),
                  filled:      false,
                  radius:      r)
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
            .init(position:     center,
                  strokeWidth:  1,
                  color:        .init(color: .green),
                  filled:       false,
                  size:         rect.size,
                  cornerRadius: 0)
          )
          primitives.append(rectangle)
          rectStart = nil
        } else {
          rectStart = location
        }

      case .arc:
        if let center = arcStart, let startPt = arcMid {
          // finalize arc (3rd tap)
          let v1 = CGPoint(x: startPt.x - center.x, y: startPt.y - center.y)
          let v2 = CGPoint(x: location.x  - center.x, y: location.y  - center.y)
          let radius = hypot(v1.x, v1.y)

          var sDeg = normalizeAngle(atan2(v1.y, v1.x).radiansToDegrees)
          var eDeg = normalizeAngle(atan2(v2.y, v2.x).radiansToDegrees)

          let cross = v1.x * v2.y - v1.y * v2.x
          let clockwise = cross < 0

          let endDeg: CGFloat
          if clockwise {
            let rawCW = normalizeAngle(sDeg - eDeg)
            endDeg = sDeg - rawCW
          } else {
            let rawCCW = normalizeAngle(eDeg - sDeg)
            endDeg = sDeg + rawCCW
          }

          let arc = GraphicPrimitiveType.arc(
            .init(position:    center,
                  strokeWidth: 1,
                  color:       .init(color: .orange),
                  filled:      false,
                  radius:      radius,
                  startAngle:  sDeg,
                  endAngle:    endDeg,
                  clockwise:   clockwise)
          )
          primitives.append(arc)
          arcStart = nil
          arcMid   = nil

        } else if arcStart != nil {
          // 2nd tap: anchor start vector
          arcMid = location
        } else {
          // 1st tap: pick center
          arcStart = location
        }

      default:
        break
      }
    }
    // Drag to move shapes
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
