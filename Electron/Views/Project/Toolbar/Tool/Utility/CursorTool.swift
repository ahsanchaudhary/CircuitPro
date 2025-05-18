import AppKit

struct CursorTool: CanvasTool {
    var id = "cursor"
    var symbolName = AppIcons.cursor
    var label = "Select"

    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        return nil // selection logic is handled by CanvasInteractionController
    }

    mutating func drawPreview(in ctx: CGContext, mouse: CGPoint, context: CanvasToolContext) {
        // Cursor tool doesn't need a preview — no-op
    }
}
