//  BaseGridLayer.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/17/25.
//

import AppKit

class BaseGridLayer: CATiledLayer {
    // MARK: - Configurable
    
    /// distance between dots/lines, in canvas units
    var unitSpacing: CGFloat = 10 { didSet { setNeedsDisplay() } }
    var majorEvery: Int      = 10
    
    var showAxes: Bool       = true { didSet { setNeedsDisplay() } }
    
    /// “logical” axis width — will be scaled by magnification
    var axisLineWidth: CGFloat = 1 { didSet { setNeedsDisplay() } }
    
    /// current zoom factor
    var magnification: CGFloat = 1.0 {
        didSet {
            updateForMagnification()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Internals
    
    private let baseAxisLineWidth: CGFloat = 1.0
    let centerX: CGFloat = 2500
    let centerY: CGFloat = 2500
    
    // tile settings
    override class func fadeDuration() -> CFTimeInterval { 0.0 }
    
    private func commonInit() {
        tileSize           = CGSize(width: 512, height: 512)
        levelsOfDetail     = 4
        levelsOfDetailBias = 4
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Scaling Hook
    
    /// By default this only scales axisLineWidth; subclasses chain-call super
    func updateForMagnification() {
        axisLineWidth = baseAxisLineWidth / magnification
    }
    
    // MARK: - Axis Drawing
    
    func drawAxes(in ctx: CGContext, tileRect: CGRect) {
        guard showAxes else { return }
        
        ctx.setLineWidth(axisLineWidth)
        
        // Y-axis
        let half = axisLineWidth / 2
        if tileRect.intersects(CGRect(
            x: centerX - half, y: tileRect.minY,
            width: axisLineWidth, height: tileRect.height)) {
            ctx.setStrokeColor(NSColor(.green.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: centerX, y: tileRect.minY))
            ctx.addLine(to: CGPoint(x: centerX, y: tileRect.maxY))
            ctx.strokePath()
        }
        
        // X-axis
        if tileRect.intersects(CGRect(
            x: tileRect.minX, y: centerY - half,
            width: tileRect.width, height: axisLineWidth)) {
            ctx.setStrokeColor(NSColor(.red.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tileRect.minX, y: centerY))
            ctx.addLine(to: CGPoint(x: tileRect.maxX, y: centerY))
            ctx.strokePath()
        }
    }
}
