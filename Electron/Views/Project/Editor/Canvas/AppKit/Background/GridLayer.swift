//  GridLayer.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/16/25.
//

import AppKit

class GridLayer: BaseGridLayer {
    var lineWidth: CGFloat = 0.5 { didSet { setNeedsDisplay() } }

    override func updateForMagnification() {
        // only scale axes
        super.updateForMagnification()
        // leave grid-line thickness fixed (or add your own scaling here)
    }

    override func draw(in ctx: CGContext) {
        let tileRect = ctx.boundingBoxOfClipPath
        let spacing = unitSpacing

        let startI = Int(floor((tileRect.minX - centerX) / spacing))
        let endI   = Int(ceil ((tileRect.maxX - centerX) / spacing))
        let startJ = Int(floor((tileRect.minY - centerY) / spacing))
        let endJ   = Int(ceil ((tileRect.maxY - centerY) / spacing))

        ctx.setShouldAntialias(false)

        // verticals
        for i in startI...endI {
            let x = centerX + CGFloat(i) * spacing
            if showAxes && i == 0 { continue }

            let isMajor = (i % majorEvery == 0)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(NSColor(.gray
                .opacity(isMajor ? 0.3 : 0.15)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x, y: tileRect.minY))
            ctx.addLine(to: CGPoint(x: x, y: tileRect.maxY))
            ctx.strokePath()
        }

        // horizontals
        for j in startJ...endJ {
            let y = centerY + CGFloat(j) * spacing
            if showAxes && j == 0 { continue }

            let isMajor = (j % majorEvery == 0)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(NSColor(.gray
                .opacity(isMajor ? 0.3 : 0.15)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: tileRect.minX, y: y))
            ctx.addLine(to: CGPoint(x: tileRect.maxX, y: y))
            ctx.strokePath()
        }

        drawAxes(in: ctx, tileRect: tileRect)
    }
}
