import Cocoa
import SwiftUI

struct GridLayerView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        view.wantsLayer = true

        let layer = GridLayer()
        layer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        layer.frame = CGRect(x: 0, y: 0, width: 3000, height: 3000)
        view.layer = layer

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let gridLayer = nsView.layer as? GridLayer else { return }
        gridLayer.setNeedsDisplay()
    }
}

class GridLayer: CALayer {
    var gridSpacing: CGFloat = 20
    var majorLineEvery: Int = 10

    override func draw(in ctx: CGContext) {
        let spacing = gridSpacing
        guard spacing >= 4 else { return }

        let bounds = self.bounds
        let columns = Int(bounds.width / spacing)
        let rows = Int(bounds.height / spacing)

        let minorLineWidth: CGFloat = 0.5
        let majorLineWidth: CGFloat = 1.0

        ctx.setShouldAntialias(false)
        ctx.setAllowsAntialiasing(false)

        for col in 0...columns {
            let x = round(CGFloat(col) * spacing) + 0.5
            let isMajor = col % majorLineEvery == 0
            ctx.setLineWidth(isMajor ? majorLineWidth : minorLineWidth)
            ctx.setStrokeColor((isMajor ? NSColor.gray.withAlphaComponent(0.7) : NSColor.gray.withAlphaComponent(0.3)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: 0))
            ctx.addLine(to: CGPoint(x: x, y: bounds.height))
            ctx.strokePath()
        }

        for row in 0...rows {
            let y = round(CGFloat(row) * spacing) + 0.5
            let isMajor = row % majorLineEvery == 0
            ctx.setLineWidth(isMajor ? majorLineWidth : minorLineWidth)
            ctx.setStrokeColor((isMajor ? NSColor.gray.withAlphaComponent(0.7) : NSColor.gray.withAlphaComponent(0.3)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: bounds.width, y: y))
            ctx.strokePath()
        }
    }
}

#Preview {
    GridLayerView()
}
