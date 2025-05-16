//  Pad+Rendering.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/16/25.
//

import AppKit

private let padHaloThickness: CGFloat = 4

extension Pad {

    /// Draws the pad using its geometric primitives and optional halo.
    func draw(in ctx: CGContext, highlight: Bool = false) {

        // ───────────────────────────────────────────── 1. main shape
        for prim in shapePrimitives {
            prim.draw(in: ctx, selected: false)
        }

        // ───────────────────────────────────────────── 2. drill hole
        for mask in maskPrimitives {
            mask.draw(in: ctx, selected: false)
        }

        // ───────────────────────────────────────────── 3. unified halo
        if highlight {
            let haloPath = CGMutablePath()

            for prim in shapePrimitives + maskPrimitives {
                let stroked = prim.makePath()
                    .copy(strokingWithWidth: padHaloThickness,
                          lineCap: .round,
                          lineJoin: .round,
                          miterLimit: 10)
                haloPath.addPath(stroked)
            }

            ctx.saveGState()
            ctx.addPath(haloPath)
            ctx.setFillColor(NSColor.systemBlue.withAlphaComponent(0.4).cgColor)
            ctx.fillPath()
            ctx.restoreGState()
        }
    }
}
