import SwiftUI
import AppKit

class DottedLayer: CATiledLayer {
    /// The spacing between dots.
    var unitSpacing: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    /// The radius for each dot.
    var dotRadius: CGFloat = 1
    /// Every nth dot is drawn as “major” (with higher opacity).
    var majorEvery: Int = 10

    override class func fadeDuration() -> CFTimeInterval {
        return 0.0  // Disable fade for immediate updates.
    }

    override init() {
        super.init()
        // Tiling configuration.
        tileSize = CGSize(width: 256, height: 256)
        levelsOfDetail = 4
        levelsOfDetailBias = 4
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tileSize = CGSize(width: 256, height: 256)
        levelsOfDetail = 4
        levelsOfDetailBias = 4
    }

    override func draw(in ctx: CGContext) {
        let tileRect = ctx.boundingBoxOfClipPath
        let spacing = unitSpacing
        let radius = dotRadius
        let majorEvery = self.majorEvery

        // Determine the range of dot indices to draw.
        let minX = Int(tileRect.minX / spacing)
        let maxX = Int(tileRect.maxX / spacing)
        let minY = Int(tileRect.minY / spacing)
        let maxY = Int(tileRect.maxY / spacing)

        for x in minX...maxX {
            for y in minY...maxY {
                let px = CGFloat(x) * spacing
                let py = CGFloat(y) * spacing
                let isMajor = (x % majorEvery == 0) || (y % majorEvery == 0)
                let color = NSColor.gray.withAlphaComponent(isMajor ? 0.7 : 0.3).cgColor

                ctx.setFillColor(color)
                ctx.fillEllipse(in: CGRect(x: px - radius,
                                           y: py - radius,
                                           width: radius * 2,
                                           height: radius * 2))
            }
        }
    }
}


struct DottedLayerView: View {
    /// External configurable dot spacing.
    var unitSpacing: CGFloat = 10
    
    var body: some View {
        LayerHostingRepresentable<DottedLayer>(
            frame: CGRect(origin: .zero, size: CGSize(width: 3000, height: 3000)),
            createLayer: {
                let layer = DottedLayer()
                layer.unitSpacing = unitSpacing
                return layer
            },
            updateLayer: { (layer: DottedLayer) in
                layer.unitSpacing = unitSpacing
            }
        )
    }
}

#Preview {
    DottedLayerView()
}
