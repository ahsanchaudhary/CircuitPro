import SwiftUI

struct CircleTool: CanvasTool {
    var id = "circle"
    var symbolName = AppIcons.circle
    var label = "Circle"
    
    private var center: CGPoint?
    
    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        if let c = center {
            let r = hypot(location.x - c.x, location.y - c.y)
            let circle = CirclePrimitive(
                position: c,
                strokeWidth: 1,
                color: .init(color: .blue),
                filled: false,
                radius: r
            )
            center = nil
            return .primitive(.circle(circle))
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
                    Circle()
                        .stroke(.blue, style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .frame(width: radius * 2, height: radius * 2)
                        .position(c)
                    
                    Path { path in
                        path.move(to: c)
                        path.addLine(to: mousePosition)
                    }
                    .stroke(.gray.opacity(0.5), style: StrokeStyle(lineCap: .round))
                    
                    
                    Text(String(format: "%.1f", radius / 4))
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .padding(4)
                        .background(.thinMaterial)
                        .clipAndStroke(with: .capsule)
                        .adjustedForMagnification()
                        .position(x: (c.x + mousePosition.x) / 2,
                                  y: (c.y + mousePosition.y) / 2 - 10)
              
                }
                .allowsHitTesting(false)
            }
        }
    }
}
