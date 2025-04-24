//
//  GridLayer.swift
//  Electron
//
//  “Solid-line” version that now anchors every line on the same
//  world origin as your dotted grid – so 0.1 mm steps stay aligned
//  even when the visual multiplier is 16 × or 32 ×.
//
//  © 2025 George Tchelidze
//

import SwiftUI
import AppKit

// MARK: – Grid-size definitions -----------------------------------------------------------

/// Same rule table you already use for the dotted layer
private let visualDisplayRules: [CGFloat: [(zoom: CGFloat, mult: CGFloat)]] = [
    GridSpacing.mm1.spacingPoints:    [(1.5,  2.0),                (.infinity, 1)],
    GridSpacing.mm0_5.spacingPoints:  [(1.5,  4.0), (2.5, 2.0),    (.infinity, 1)],
    GridSpacing.mm0_25.spacingPoints: [(2.5,  8.0), (3.5, 4.0),
                                       (4.5,  2.0),                (.infinity, 1)],
    GridSpacing.mm0_1.spacingPoints:  [(2.5, 32.0), (4.5,16.0), (6.5, 8.0),
                                       (8.5,  4.0), (10.5,2.0),    (.infinity, 1)]
]

@inline(__always)
private func visualGridSpacing(for base: CGFloat, zoom: CGFloat) -> CGFloat {
    guard let rules = visualDisplayRules[base] else { return base }
    for (threshold, m) in rules where zoom < threshold { return base * m }
    return base
}

@inline(__always)
private func pxConstant(_ pt: CGFloat, zoom: CGFloat) -> CGFloat { pt / zoom }

// MARK: – CATiledLayer --------------------------------------------------------------------

final class GridLayer: CATiledLayer {
    
    // --- knobs you can tweak from SwiftUI
    var unitSpacing: CGFloat = 10   { didSet { setNeedsDisplay() } }
    var majorLineEvery       = 10
    var showAxes             = true { didSet { setNeedsDisplay() } }
    var zoomFactor:   CGFloat = 1   { didSet { setNeedsDisplay() } }
    
    // --- boilerplate
    override class func fadeDuration() -> CFTimeInterval { 0 }
    override init() {
        super.init()
        tileSize          = .init(width: 256, height: 256)
        levelsOfDetail     = 4
        levelsOfDetailBias = 4
    }
    required init?(coder: NSCoder) { fatalError("use programme init") }
    
    // --- drawing
    override func draw(in ctx: CGContext) {
        // 1. If the step is <4 px on screen, grid would be a solid fill → skip
        let spacing      = unitSpacing
        let stridePx     = spacing * zoomFactor
        guard stridePx >= 4 else { return }
        
        // 2. Work *relative to the world-origin* so everything lines up
        let originX: CGFloat = 2500          // same numbers as dotted layer
        let originY: CGFloat = 2500
        
        let tile = ctx.boundingBoxOfClipPath
        let minI = Int(floor((tile.minX - originX) / spacing))
        let maxI = Int(ceil ((tile.maxX - originX) / spacing))
        let minJ = Int(floor((tile.minY - originY) / spacing))
        let maxJ = Int(ceil ((tile.maxY - originY) / spacing))
        
        // 3. Constant-pixel stroke widths
        let minorW = pxConstant(0.5, zoom: zoomFactor)
        let majorW = pxConstant(1.0, zoom: zoomFactor)
        let axisW  = majorW
        
        ctx.setShouldAntialias(false)
        
        // 4. Vertical lines (indices relative to origin)
        for i in minI...maxI {
            let x = originX + CGFloat(i) * spacing
            if showAxes && abs(i) == 0 { continue }          // skip axis itself
            
            let isMajor = (i % majorLineEvery == 0)
            ctx.setLineWidth(isMajor ? majorW : minorW)
            ctx.setStrokeColor(
                (isMajor ? NSColor.gray.withAlphaComponent(0.3)
                         : NSColor.gray.withAlphaComponent(0.2)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: tile.minY))
            ctx.addLine(to: CGPoint(x: x, y: tile.maxY))
            ctx.strokePath()
        }
        
        // 5. Horizontal lines
        for j in minJ...maxJ {
            let y = originY + CGFloat(j) * spacing
            if showAxes && abs(j) == 0 { continue }
            
            let isMajor = (j % majorLineEvery == 0)
            ctx.setLineWidth(isMajor ? majorW : minorW)
            ctx.setStrokeColor(
                (isMajor ? NSColor.gray.withAlphaComponent(0.3)
                         : NSColor.gray.withAlphaComponent(0.2)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tile.minX, y: y))
            ctx.addLine(to: CGPoint(x: tile.maxX, y: y))
            ctx.strokePath()
        }
        
        // 6. Axes
        guard showAxes else { return }
        ctx.setLineWidth(axisW)
        
        if tile.intersects(CGRect(x: originX - axisW*0.5, y: tile.minY,
                                  width: axisW, height: tile.height)) {
            ctx.setStrokeColor(NSColor.systemGreen.withAlphaComponent(0.75).cgColor)
            ctx.stroke(CGRect(x: originX, y: tile.minY, width: 0, height: tile.height))
        }
        if tile.intersects(CGRect(x: tile.minX, y: originY - axisW*0.5,
                                  width: tile.width, height: axisW)) {
            ctx.setStrokeColor(NSColor.systemRed.withAlphaComponent(0.75).cgColor)
            ctx.stroke(CGRect(x: tile.minX, y: originY, width: tile.width, height: 0))
        }
    }
}

// MARK: – SwiftUI wrapper ---------------------------------------------------

struct GridLayerView: View {
    @Environment(\.canvasManager)      private var canvasManager
    @Environment(\.scrollViewManager)  private var scrollViewManager
    
    var body: some View {
        let zoom = scrollViewManager.currentMagnification
        let unit = visualGridSpacing(for: canvasManager.gridSpacing.spacingPoints,
                                     zoom: zoom)
        
        LayerHostingRepresentable<GridLayer>(
            frame: CGRect(origin: .zero, size: canvasManager.canvasSize),
            createLayer: {
                let layer            = GridLayer()
                layer.unitSpacing    = unit
                layer.zoomFactor     = zoom
                layer.majorLineEvery = 10
                layer.showAxes       = canvasManager.enableAxesBackground
                return layer
            },
            updateLayer: { layer in
                layer.unitSpacing = unit
                layer.zoomFactor  = zoom
                layer.showAxes    = canvasManager.enableAxesBackground
            }
        )
    }
}

#Preview {
    GridLayerView()
}
