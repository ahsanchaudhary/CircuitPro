//
//  LineHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI


extension GraphicPrimitiveType {
  @ViewBuilder
    static func renderHandles(for primitive: GraphicPrimitiveType) -> some View {
    switch primitive {
    case .line(let line):
      LineHandles(line: line)

    case .rectangle(let rect):
      RectangleHandles(rect: rect)

    case .circle(let circle):
      CircleHandles(circle: circle)

    case .arc:
      EmptyView()
    }
  }
}

extension GraphicPrimitiveType {
    func handles() -> [PrimitiveHandle] {
        switch self {
        case .rectangle(let r):
            let halfW = r.size.width / 2, halfH = r.size.height / 2
            let dirs: [CGVector] = [
                .init(dx:-1,dy:-1), .init(dx:1,dy:-1),
                .init(dx:-1,dy: 1), .init(dx:1,dy: 1)
            ]
            return dirs.map { dir in
                PrimitiveHandle(
                    kind: .rectangleCorner(dir),
                    primitiveID: r.id,
                    position: CGPoint(
                        x: r.position.x + dir.dx * halfW,
                        y: r.position.y + dir.dy * halfH
                    )
                )
            }
        case .circle(let c):
            return [
                PrimitiveHandle(
                    kind: .circleRadius,
                    primitiveID: c.id,
                    position: CGPoint(x: c.position.x + c.radius, y: c.position.y)
                )
            ]
        case .line(let l):
            return [
                PrimitiveHandle(
                    kind: .lineStart,
                    primitiveID: l.id,
                    position: l.start
                ),
                PrimitiveHandle(
                    kind: .lineEnd,
                    primitiveID: l.id,
                    position: l.end
                )
            ]
        default:
            return []
        }
    }
}

func allHandles(selected: [GraphicPrimitiveType]) -> [PrimitiveHandle] {
    selected.flatMap { $0.handles() }
}


enum PrimitiveHandleKind: Hashable {
    case rectangleCorner(CGVector)    // (dx,dy) for 4 corners
    case circleRadius                 // one handle (positive X right now)
    case lineStart
    case lineEnd
}

// Unified handle struct
struct PrimitiveHandle: Hashable, Identifiable {
    let kind: PrimitiveHandleKind
    let primitiveID: UUID
    let position: CGPoint

    var id: String {
        "\(primitiveID.uuidString)-\(kind)"
    }
}
