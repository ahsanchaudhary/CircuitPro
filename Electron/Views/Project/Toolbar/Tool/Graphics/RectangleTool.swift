import SwiftUI

struct RectangleTool: CanvasTool {
    var id = "rectangle"
    var symbolName = AppIcons.rectangle
    var label = "Rectangle"
    
    private var start: CGPoint?
    
    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        handleTap(at: location)
    }
    
    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> some View {
        preview(mousePosition: mousePosition)
    }

    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        if let s = start {
            let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: location, size: .zero))
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let size = CGSize(width: rect.width, height: rect.height)
            
            let rectangle = RectanglePrimitive(
                position: center,
                strokeWidth: 1,
                color: .init(color: .blue),
                filled: false,
                size: size,
                cornerRadius: 0
            )
            
            start = nil
            return .primitive(.rectangle(rectangle))
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
                    .stroke(.blue, style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .allowsHitTesting(false)
            }
        }
    }
}
