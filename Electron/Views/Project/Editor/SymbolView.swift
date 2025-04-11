import SwiftUI

// MARK: - Custom Shape Structs

struct LineShape: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        
        return path
    }
}

struct ArcShape: Shape {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise)
        return path
    }
}

struct PolygonShape: Shape {
    var points: [CGPoint]
    var closed: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        if closed {
            path.closeSubpath()
        }
        return path
    }
}

// MARK: - Symbol View

struct SymbolView: View {
    let symbol: Symbol

    var body: some View {
        ZStack {
            if !symbol.primitives.isEmpty {
                ForEach(symbol.primitives) { primitive in
                    renderPrimitive(primitive)
                }
            } else {
                Circle()
                    .fill(symbol.color)
                    .frame(width: 15, height: 15)
            }
        }
        .position(x: symbol.x, y: symbol.y)
        .zIndex(10)
    }

    @ViewBuilder
    private func renderPrimitive(_ primitive: GraphicPrimitiveType) -> some View {
        switch primitive {

        case .line(let line):
            LineShape(start: line.start.shiftedByCenter, end: line.end.shiftedByCenter)
                .stroke(line.color.color, lineWidth: line.strokeWidth)
                .contentShape(LineShape(start: line.start.shiftedByCenter, end: line.end.shiftedByCenter))
                .background(Color.clear)

        case .rectangle(let rect):
            RoundedRectangle(cornerRadius: rect.cornerRadius)
                .stroke(rect.color.color, lineWidth: rect.strokeWidth)
                .background(
                    rect.filled ?
                        RoundedRectangle(cornerRadius: rect.cornerRadius)
                            .fill(rect.color.color)
                        : nil
                )
                .frame(width: rect.size.width, height: rect.size.height)
                .position(rect.position.shiftedByCenter)

        case .circle(let circle):
            Circle()
                .stroke(circle.color.color, lineWidth: circle.strokeWidth)
                .background(
                    circle.filled ?
                        Circle().fill(circle.color.color)
                        : nil
                )
                .frame(width: circle.radius * 2, height: circle.radius * 2)
                .position(circle.position.shiftedByCenter)

        case .arc(let arc):
            ArcShape(center: arc.position.shiftedByCenter,
                     radius: arc.radius,
                     startAngle: arc.startAngle.angle,
                     endAngle: arc.endAngle.angle,
                     clockwise: arc.clockwise)
                .stroke(arc.color.color, lineWidth: arc.strokeWidth)
                

        case .polygon(let polygon):
            PolygonShape(points: polygon.points.map { $0.shiftedByCenter },
                         closed: polygon.closed)
                .stroke(polygon.color.color, lineWidth: polygon.strokeWidth)
        }
    }
}

// MARK: - Preview

#Preview {
    SymbolView(symbol: Symbol(x: 0, y: 0, initialPosition: nil, color: .red, primitives: []))
}
