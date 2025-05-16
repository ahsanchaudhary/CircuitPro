//
//  DottedLayer.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/15/25.
//
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
