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

        // Disable antialiasing for crisp lines.
        ctx.setShouldAntialias(false)
        ctx.setAllowsAntialiasing(false)
        
        // Draw vertical grid lines.
        for col in 0...columns {
            let x = round(CGFloat(col) * spacing) + 0.5
            let isMajor = (col % majorLineEvery == 0)
            ctx.setLineWidth(isMajor ? majorLineWidth : minorLineWidth)
            ctx.setStrokeColor((isMajor
                                  ? NSColor.gray.withAlphaComponent(0.5)
                                  : NSColor.gray.withAlphaComponent(0.25)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: 0))
            ctx.addLine(to: CGPoint(x: x, y: bounds.height))
            ctx.strokePath()
        }
        
        // Draw horizontal grid lines.
        for row in 0...rows {
            let y = round(CGFloat(row) * spacing) + 0.5
            let isMajor = (row % majorLineEvery == 0)
            ctx.setLineWidth(isMajor ? majorLineWidth : minorLineWidth)
            ctx.setStrokeColor((isMajor
                                  ? NSColor.gray.withAlphaComponent(0.5)
                                  : NSColor.gray.withAlphaComponent(0.3)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: bounds.width, y: y))
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
