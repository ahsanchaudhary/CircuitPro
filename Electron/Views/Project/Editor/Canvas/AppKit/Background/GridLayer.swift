//
//  GridLayer.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/16/25.
//
import SwiftUI
import AppKit

class GridLayer: CATiledLayer {
    var unitSpacing: CGFloat = 10 {
        didSet { setNeedsDisplay() }
    }
    
    var majorEvery: Int = 10
    var showAxes: Bool = true {
        didSet { setNeedsDisplay() }
    }
    
    var axisLineWidth: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    
    var lineWidth: CGFloat = 0.5 {
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
        let tileRect = ctx.boundingBoxOfClipPath
        let centerX: CGFloat = 2500
        let centerY: CGFloat = 2500

        let startI = Int(floor((tileRect.minX - centerX) / spacing))
        let endI   = Int(ceil ((tileRect.maxX - centerX) / spacing))
        let startJ = Int(floor((tileRect.minY - centerY) / spacing))
        let endJ   = Int(ceil ((tileRect.maxY - centerY) / spacing))
        
        ctx.setShouldAntialias(false)
        
        // Vertical lines
        for i in startI...endI {
            let x = centerX + CGFloat(i) * spacing
            if showAxes && i == 0 { continue }
            
            let isMajor = i % majorEvery == 0
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor((isMajor ? NSColor(.gray.opacity(0.3))
                                        : NSColor(.gray.opacity(0.15))).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: tileRect.minY))
            ctx.addLine(to: CGPoint(x: x, y: tileRect.maxY))
            ctx.strokePath()
        }

        // Horizontal lines
        for j in startJ...endJ {
            let y = centerY + CGFloat(j) * spacing
            if showAxes && j == 0 { continue }
            
            let isMajor = j % majorEvery == 0
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor((isMajor ? NSColor(.gray.opacity(0.3))
                                        : NSColor(.gray.opacity(0.15))).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tileRect.minX, y: y))
            ctx.addLine(to: CGPoint(x: tileRect.maxX, y: y))
            ctx.strokePath()
        }

        // Axes
        guard showAxes else { return }
        ctx.setLineWidth(axisLineWidth)

        if tileRect.intersects(CGRect(x: centerX - axisLineWidth / 2,
                                      y: tileRect.minY,
                                      width: axisLineWidth,
                                      height: tileRect.height)) {
            ctx.setStrokeColor(NSColor(.green.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: centerX, y: tileRect.minY))
            ctx.addLine(to: CGPoint(x: centerX, y: tileRect.maxY))
            ctx.strokePath()
        }

        if tileRect.intersects(CGRect(x: tileRect.minX,
                                      y: centerY - axisLineWidth / 2,
                                      width: tileRect.width,
                                      height: axisLineWidth)) {
            ctx.setStrokeColor(NSColor(.red.opacity(0.75)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tileRect.minX, y: centerY))
            ctx.addLine(to: CGPoint(x: tileRect.maxX, y: centerY))
            ctx.strokePath()
        }
    }
}
