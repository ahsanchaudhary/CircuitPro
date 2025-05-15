import SwiftUI
import AppKit


class DottedLayer: CATiledLayer {
    var unitSpacing: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    
    var dotRadius: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    
    
    var majorEvery: Int = 10
    var showAxes: Bool = true {
        didSet { setNeedsDisplay() }
    }
    
    var axisLineWidth: CGFloat = 1 {
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
        let spacing = unitSpacing
        let radius  = dotRadius
        let tileRect = ctx.boundingBoxOfClipPath
        
        // 1) Use your true world center for the axes:
        let centerX: CGFloat = 2500
        let centerY: CGFloat = 2500
        
        // 2) Compute the integer grid indices that land inside this tile:
        let startI = Int(floor((tileRect.minX - centerX) / spacing))
        let endI   = Int(ceil ((tileRect.maxX - centerX) / spacing))
        let startJ = Int(floor((tileRect.minY - centerY) / spacing))
        let endJ   = Int(ceil ((tileRect.maxY - centerY) / spacing))
        
        // 3) Draw all dots so that index (0,0) sits exactly at the axis:
        for i in startI...endI {
            let px = centerX + CGFloat(i) * spacing
            for j in startJ...endJ {
                let py = centerY + CGFloat(j) * spacing
                
                // skip drawing over the axis lines themselves
                if showAxes && (i == 0 || j == 0) {
                    continue
                }
                
                let isMajor = (i % majorEvery == 0) || (j % majorEvery == 0)
                let color = NSColor.gray.withAlphaComponent(isMajor ? 0.7 : 0.3).cgColor
                ctx.setFillColor(color)
                ctx.fillEllipse(in: CGRect(
                    x: px - radius,
                    y: py - radius,
                    width:  radius*2,
                    height: radius*2
                ))
            }
        }
        
        // 4) Now draw the axes at that exact same center:
        guard showAxes else { return }
        
        ctx.setLineWidth(axisLineWidth)
        
        // Y-axis
        if tileRect.intersects(CGRect(x: centerX - axisLineWidth/2,
                                      y: tileRect.minY,
                                      width: axisLineWidth,
                                      height: tileRect.height)) {
            ctx.setStrokeColor(NSColor(Color.green.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: centerX, y: tileRect.minY))
            ctx.addLine(to: CGPoint(x: centerX, y: tileRect.maxY))
            ctx.strokePath()
        }
        
        // X-axis
        if tileRect.intersects(CGRect(x: tileRect.minX,
                                      y: centerY - axisLineWidth/2,
                                      width: tileRect.width,
                                      height: axisLineWidth)) {
            ctx.setStrokeColor(NSColor(Color.red.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tileRect.minX, y: centerY))
            ctx.addLine(to: CGPoint(x: tileRect.maxX, y: centerY))
            ctx.strokePath()
        }
    }
    
}

struct DottedLayerView: View {
    @Environment(CanvasManager.self) private var canvasManager
    @Environment(ScrollViewManager.self) private var scrollViewManager
    
    
    let visualDisplayRules: [CGFloat: [(zoomThreshold: CGFloat, spacingMultiplier: CGFloat)]] = [
        GridSpacing.mm1.spacingPoints: [
            (1.5, 2.0),
            (CGFloat.infinity, 1.0)
        ],
        GridSpacing.mm0_5.spacingPoints: [
            (1.5, 4.0),
            (2.5, 2.0),
            (CGFloat.infinity, 1.0)
        ],
        GridSpacing.mm0_25.spacingPoints: [
            (2.5, 8.0),
            (4.5, 4.0),
            (6.5, 2.0),
            (CGFloat.infinity, 1.0)
        ]
        
    ]
    
    
    func screenCorrectedDotRadius(for magnification: CGFloat, base: CGFloat = 1.0) -> CGFloat {
        let baseSpacing = canvasManager.gridSpacing.spacingPoints
        let raw = base / magnification
        
        // Prevent dot size from growing above base size
        let clamped = min(base, raw)
        
        if baseSpacing == GridSpacing.mm5.spacingPoints {
            return max(clamped, base / 2.0)
        }
        
        if baseSpacing == GridSpacing.mm2_5.spacingPoints {
            return max(clamped, base / 5.0)
        }
        
        return clamped
    }
    
    
    
    
    func visualGridSpacing(for baseSpacing: CGFloat, zoom: CGFloat) -> CGFloat {
        guard let rules = visualDisplayRules[baseSpacing] else {
            return baseSpacing
        }
        
        for (threshold, multiplier) in rules {
            if zoom < threshold {
                return baseSpacing * multiplier
            }
        }
        
        return baseSpacing
    }
    
    
    
    
    var body: some View {
        let zoom = scrollViewManager.currentMagnification
        let unit = visualGridSpacing(
            for: canvasManager.gridSpacing.spacingPoints,
            zoom: zoom
        )
        let dot  = screenCorrectedDotRadius(for: zoom)
        
        // axis width = base / zoom → stays visually constant when you zoom
        let axisWidth = 1 / zoom
        
        return LayerHostingRepresentable<DottedLayer>(
            frame: CGRect(origin: .zero, size: canvasManager.canvasSize),
            createLayer: {
                let layer = DottedLayer()
                layer.unitSpacing     = unit
                layer.dotRadius       = dot
                layer.axisLineWidth   = axisWidth
                layer.showAxes        = canvasManager.enableAxesBackground
                return layer
            },
            updateLayer: { layer in
                layer.unitSpacing     = unit
                layer.dotRadius       = dot
                layer.axisLineWidth   = axisWidth
                layer.showAxes        = canvasManager.enableAxesBackground
            }
        )
    }
}


#Preview {
    DottedLayerView()
}
