import SwiftUI
import AppKit

struct DottedLayerView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        view.wantsLayer = true

        let layer = DottedLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 3000, height: 3000)
        layer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        view.layer = layer

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let gridLayer = nsView.layer as? DottedLayer else { return }
        gridLayer.setNeedsDisplay()
    }
}

class DottedLayer: CALayer {
    var dotSpacing: CGFloat = 20
    var dotRadius: CGFloat = 1
    var majorLineEvery: Int = 10

    override func draw(in ctx: CGContext) {
        let spacing = dotSpacing
        guard spacing >= 2 else { return } // Avoid overdraw at tiny spacing

        let bounds = self.bounds
        let columns = Int(bounds.width / spacing)
        let rows = Int(bounds.height / spacing)

        let minorColor = NSColor.gray.withAlphaComponent(0.3).cgColor
        let majorColor = NSColor.gray.withAlphaComponent(0.7).cgColor

        ctx.setShouldAntialias(true)
        ctx.setAllowsAntialiasing(true)
        ctx.interpolationQuality = .none

        for col in 0...columns {
            for row in 0...rows {
                let x = CGFloat(col) * spacing
                let y = CGFloat(row) * spacing

                let isMajorCol = col % majorLineEvery == 0
                let isMajorRow = row % majorLineEvery == 0
                let isMajor = isMajorCol || isMajorRow

                ctx.setFillColor(isMajor ? majorColor : minorColor)

                let dotRect = CGRect(
                    x: round(x - dotRadius) + 0.5,
                    y: round(y - dotRadius) + 0.5,
                    width: dotRadius * 2,
                    height: dotRadius * 2
                )

                ctx.fillEllipse(in: dotRect)
            }
        }
    }
}

#Preview {
    DottedLayerView()
}
