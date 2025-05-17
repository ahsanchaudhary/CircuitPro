import AppKit

class DottedLayer: BaseGridLayer {

    private let baseDotRadius: CGFloat = 1
    private var dotRadius:    CGFloat = 1          { didSet { setNeedsDisplay() } }

    // update zoom-dependent parameters
    override func updateForMagnification() {
        super.updateForMagnification()

        dotRadius       = baseDotRadius / max(magnification, 1)
    }

    // draw a single tile
    override func draw(in ctx: CGContext) {
        let spacing = adjustedSpacing()
        let r       = dotRadius
        let tile    = ctx.boundingBoxOfClipPath

        let startI = Int(floor((tile.minX - centerX) / spacing))
        let endI   = Int(ceil ((tile.maxX - centerX) / spacing))
        let startJ = Int(floor((tile.minY - centerY) / spacing))
        let endJ   = Int(ceil ((tile.maxY - centerY) / spacing))

        for i in startI...endI {
            let px = centerX + CGFloat(i) * spacing
            for j in startJ...endJ {
                let py = centerY + CGFloat(j) * spacing
                if showAxes && (i == 0 || j == 0) { continue }

                let isMajor = (i % majorEvery == 0) || (j % majorEvery == 0)
                let alpha   = (isMajor ? 0.7 : 0.3)
                ctx.setFillColor(NSColor.gray.withAlphaComponent(alpha).cgColor)
                ctx.fillEllipse(in: .init(x:px-r, y:py-r, width:r*2, height:r*2))
            }
        }
        drawAxes(in: ctx, tileRect: tile)
    }
}
