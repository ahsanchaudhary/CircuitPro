import Cocoa
import SwiftUI

class GridLayer: CATiledLayer {
    /// The spacing between grid lines.
    var unitSpacing: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    /// Every nth line is drawn as “major.”
    var majorLineEvery: Int = 10

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
        let spacing = unitSpacing
        guard spacing >= 4 else { return }

        let bounds = self.bounds
        let columns = Int(bounds.width / spacing)
        let rows = Int(bounds.height / spacing)
        let minorLineWidth: CGFloat = 0.5
        let majorLineWidth: CGFloat = 1.0

        let centerX: CGFloat = 1500
        let centerY: CGFloat = 1500

        // Disable antialiasing for crisp lines.
        ctx.setShouldAntialias(false)
        ctx.setAllowsAntialiasing(false)

        // Draw vertical grid lines.
        for col in 0...columns {
            let x = round(CGFloat(col) * spacing) + 0.5

            // Skip if it's the center axis
            if abs(x - centerX) < spacing / 2 {
                continue
            }

            let isMajor = (col % majorLineEvery == 0)
            ctx.setLineWidth(isMajor ? majorLineWidth : minorLineWidth)
            ctx.setStrokeColor((isMajor
                                  ? NSColor.gray.withAlphaComponent(0.3)
                                  : NSColor.gray.withAlphaComponent(0.2)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: 0))
            ctx.addLine(to: CGPoint(x: x, y: bounds.height))
            ctx.strokePath()
        }

        // Draw horizontal grid lines.
        for row in 0...rows {
            let y = round(CGFloat(row) * spacing) + 0.5

            // Skip if it's the center axis
            if abs(y - centerY) < spacing / 2 {
                continue
            }

            let isMajor = (row % majorLineEvery == 0)
            ctx.setLineWidth(isMajor ? majorLineWidth : minorLineWidth)
            ctx.setStrokeColor((isMajor
                                  ? NSColor.gray.withAlphaComponent(0.3)
                                  : NSColor.gray.withAlphaComponent(0.2)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: bounds.width, y: y))
            ctx.strokePath()
        }

        // Draw center Y axis (green)
        if bounds.contains(CGPoint(x: centerX, y: bounds.midY)) {
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(NSColor(Color.green.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: centerX, y: 0))
            ctx.addLine(to: CGPoint(x: centerX, y: bounds.height))
            ctx.strokePath()
        }

        // Draw center X axis (red)
        if bounds.contains(CGPoint(x: bounds.midX, y: centerY)) {
            ctx.setLineWidth(1.0)
            ctx.setStrokeColor(NSColor(Color.red.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: centerY))
            ctx.addLine(to: CGPoint(x: bounds.width, y: centerY))
            ctx.strokePath()
        }
    }

}

struct GridLayerView: View {
    /// External configurable grid spacing.
    var unitSpacing: CGFloat = 10

    var body: some View {
        LayerHostingRepresentable<GridLayer>(
            frame: CGRect(origin: .zero, size: CGSize(width: 3000, height: 3000)),
            createLayer: {
                let layer = GridLayer()
                layer.unitSpacing = unitSpacing
                return layer
            },
            updateLayer: { (layer: GridLayer) in
                layer.unitSpacing = unitSpacing
            }
        )
    }
}

#Preview {
    GridLayerView()
}
