import SwiftUI
import AppKit

class DottedLayer: CATiledLayer {
    var unitSpacing: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }

    var dotRadius: CGFloat = 1
    var majorEvery: Int = 10
    var showAxes: Bool = true {
        didSet { setNeedsDisplay() }
    }

    override class func fadeDuration() -> CFTimeInterval {
        return 0.0
    }

    override init() {
        super.init()
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

        let minX = Int(tileRect.minX / spacing)
        let maxX = Int(tileRect.maxX / spacing)
        let minY = Int(tileRect.minY / spacing)
        let maxY = Int(tileRect.maxY / spacing)

        let centerX: CGFloat = 1500
        let centerY: CGFloat = 1500

        for x in minX...maxX {
            for y in minY...maxY {
                let px = CGFloat(x) * spacing
                let py = CGFloat(y) * spacing

                // Only skip if axes are shown
                if showAxes && (abs(px - centerX) < spacing / 2 || abs(py - centerY) < spacing / 2) {
                    continue
                }

                let isMajor = (x % majorEvery == 0) || (y % majorEvery == 0)
                let color = NSColor.gray.withAlphaComponent(isMajor ? 0.7 : 0.3).cgColor

                ctx.setFillColor(color)
                ctx.fillEllipse(in: CGRect(x: px - radius,
                                           y: py - radius,
                                           width: radius * 2,
                                           height: radius * 2))
            }
        }

        guard showAxes else { return }

        ctx.setLineWidth(1)

        // Y-axis
        if tileRect.intersects(CGRect(x: centerX, y: tileRect.minY, width: 1, height: tileRect.height)) {
            ctx.setStrokeColor(NSColor(Color.green.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: centerX, y: tileRect.minY))
            ctx.addLine(to: CGPoint(x: centerX, y: tileRect.maxY))
            ctx.strokePath()
        }

        // X-axis
        if tileRect.intersects(CGRect(x: tileRect.minX, y: centerY, width: tileRect.width, height: 1)) {
            ctx.setStrokeColor(NSColor(Color.red.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tileRect.minX, y: centerY))
            ctx.addLine(to: CGPoint(x: tileRect.maxX, y: centerY))
            ctx.strokePath()
        }
    }
}


struct DottedLayerView: View {
    var unitSpacing: CGFloat = 10
    @Environment(\.canvasManager) private var canvasManager

    var body: some View {
        LayerHostingRepresentable<DottedLayer>(
            frame: CGRect(origin: .zero, size: CGSize(width: 3000, height: 3000)),
            createLayer: {
                let layer = DottedLayer()
                layer.unitSpacing = unitSpacing
                layer.showAxes = canvasManager.enableAxesBackground
                return layer
            },
            updateLayer: { (layer: DottedLayer) in
                layer.unitSpacing = unitSpacing
                layer.showAxes = canvasManager.enableAxesBackground
            }
        )
    }
}


#Preview {
    DottedLayerView()
}
