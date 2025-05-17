//  DottedLayer.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/15/25.
//

import AppKit

class DottedLayer: BaseGridLayer {
    var dotRadius: CGFloat = 1 { didSet { setNeedsDisplay() } }
    private let baseDotRadius: CGFloat = 1.0

    override func updateForMagnification() {
        // 1) scale axes
        super.updateForMagnification()
        // 2) compute dot size (never grow when zoom < 1)
        let scale = max(magnification, 1.0)
        dotRadius = baseDotRadius / scale
    }

    override func draw(in ctx: CGContext) {
        let tileRect = ctx.boundingBoxOfClipPath
        let spacing = unitSpacing
        let r       = dotRadius

        let startI = Int(floor((tileRect.minX - centerX) / spacing))
        let endI   = Int(ceil ((tileRect.maxX - centerX) / spacing))
        let startJ = Int(floor((tileRect.minY - centerY) / spacing))
        let endJ   = Int(ceil ((tileRect.maxY - centerY) / spacing))

        for i in startI...endI {
            let px = centerX + CGFloat(i) * spacing
            for j in startJ...endJ {
                let py = centerY + CGFloat(j) * spacing
                if showAxes && (i == 0 || j == 0) { continue }

                let isMajor = (i % majorEvery == 0) || (j % majorEvery == 0)
                let alpha   = isMajor ? 0.7 : 0.3
                ctx.setFillColor(NSColor(.gray.opacity(alpha)).cgColor)
                ctx.fillEllipse(in: CGRect(
                    x: px - r, y: py - r,
                    width:  r * 2, height: r * 2
                ))
            }
        }

        drawAxes(in: ctx, tileRect: tileRect)
    }
}
