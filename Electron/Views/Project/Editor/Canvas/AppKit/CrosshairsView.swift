import AppKit

final class CrosshairsView: NSView {
    enum Style {
        /// full‐width + full‐height lines
        case full
        /// small little crosshair centered on the cursor; length = size
        case small(size: CGFloat)
    }

    /// which style to draw?
    var style: Style = .full {
        didSet { needsDisplay = true }
    }

    var location: CGPoint? {
        didSet { needsDisplay = true }
    }
    
    var magnification: CGFloat = 1.0 {
        didSet { needsDisplay = true }
    }

    
    

    override var isFlipped: Bool { true }
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext,
              let pt = location else { return }

        ctx.saveGState()
        ctx.setStrokeColor(NSColor(.blue.opacity(0.6)).cgColor)

        // Scale line width inversely with magnification
        ctx.setLineWidth(1.0 / magnification)

        switch style {
        case .full:
            ctx.beginPath()
            ctx.move(to: CGPoint(x: pt.x, y: 0))
            ctx.addLine(to: CGPoint(x: pt.x, y: bounds.height))
            ctx.move(to: CGPoint(x: 0, y: pt.y))
            ctx.addLine(to: CGPoint(x: bounds.width, y: pt.y))
            ctx.strokePath()

        case .small(let size):
            let half = size / 2
            ctx.setLineCap(.round)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: pt.x - half, y: pt.y))
            ctx.addLine(to: CGPoint(x: pt.x + half, y: pt.y))
            ctx.move(to: CGPoint(x: pt.x, y: pt.y - half))
            ctx.addLine(to: CGPoint(x: pt.x, y: pt.y + half))
            ctx.strokePath()
        }

        ctx.restoreGState()
    }

}
