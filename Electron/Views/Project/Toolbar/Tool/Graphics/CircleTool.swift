import SwiftUI

struct CircleTool: CanvasTool {
    var id = "circle"
    var symbolName = AppIcons.circle
    var label = "Circle"

    private var center: CGPoint?

    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        if let c = center {
            let r = hypot(location.x - c.x, location.y - c.y)
            let circle = CirclePrimitive(
                uuid: UUID(),
                position: c,
                radius: r,
                rotation: 0,
                strokeWidth: 1,
                color: .init(color: .blue),
                filled: false
            )
            center = nil
            return .primitive(.circle(circle))
        } else {
            center = location
            return nil
        }
    }

    mutating func drawPreview(in ctx: CGContext, mouse: CGPoint, context: CanvasToolContext) {
        guard let c = center else { return }
        let r = hypot(mouse.x - c.x, mouse.y - c.y)
        let rect = CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)

        ctx.saveGState()
        ctx.setStrokeColor(NSColor(.blue).cgColor)
        ctx.setLineWidth(1)
        ctx.setLineDash(phase: 0, lengths: [4])
        ctx.strokeEllipse(in: rect)
        ctx.restoreGState()
    }
}
