import AppKit

final class CrosshairsView: NSView {

    /// which style to draw?
    var crosshairsStyle: CrosshairsStyle = .centeredCross {
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
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }

        ctx.saveGState()
        ctx.setStrokeColor(NSColor(.blue.opacity(0.6)).cgColor)
        ctx.setLineWidth(1.0 / magnification)

        switch crosshairsStyle {
        case .hidden:
            return  // draw nothing

        case .fullScreenLines:
            guard let pt = location else { return }
            ctx.beginPath()
            ctx.move(to: CGPoint(x: pt.x, y: 0))
            ctx.addLine(to: CGPoint(x: pt.x, y: bounds.height))
            ctx.move(to: CGPoint(x: 0, y: pt.y))
            ctx.addLine(to: CGPoint(x: bounds.width, y: pt.y))
            ctx.strokePath()

        case .centeredCross:
            guard let pt = location else { return }
            let size: CGFloat = 20.0
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
