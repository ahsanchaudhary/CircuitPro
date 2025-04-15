import SwiftUI
import SwiftData


struct SymbolView: View {
    let symbolInstance: SymbolInstance

    @Environment(\.modelContext) private var modelContext
    @State private var symbol: Symbol?

    var body: some View {
        ZStack {
            if let symbol {
                if !symbol.primitives.isEmpty {
                    ForEach(symbol.primitives) { primitive in
                        renderPrimitive(primitive)
                    }
                } else {
                    Circle()
                        .frame(width: 15, height: 15)
                }
            } else {
                // Placeholder while loading or missing
                Circle()
                    .stroke(.gray)
                    .frame(width: 15, height: 15)
            }
        }
        .position(x: symbolInstance.position.x, y: symbolInstance.position.y)
        .zIndex(10)
        .task {
            await loadSymbol()
        }
    }

    private func loadSymbol() async {
        let uuid = symbolInstance.symbolUUID

        
        do {
            let descriptor = FetchDescriptor<Symbol>(
                predicate: #Predicate { $0.uuid == uuid },
                sortBy: []
            )
            let result = try modelContext.fetch(descriptor)
            symbol = result.first
        } catch {
            print("Failed to fetch symbol: \(error)")
        }
    }

    @ViewBuilder
    private func renderPrimitive(_ primitive: GraphicPrimitiveType) -> some View {
        switch primitive {

        case .line(let line):
            LineShape(start: line.start.shiftedByCenter, end: line.end.shiftedByCenter)
                .stroke(line.color.color, lineWidth: line.strokeWidth)
            
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
            ArcShape(
                center: arc.position.shiftedByCenter,
                radius: arc.radius,
                startAngle: .degrees(arc.startAngle),
                endAngle: .degrees(arc.endAngle),
                clockwise: arc.clockwise
            )

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
    SymbolView(symbolInstance: SymbolInstance(symbolId: .init(), position: .init(x: 0, y: 0)))
}
