//  RulerTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/18/25.

import SwiftUI

struct RulerTool: CanvasTool {
    var id: String = "ruler"
    var symbolName: String = AppIcons.ruler
    var label: String = "Ruler"

    private var start: CGPoint? = nil
    private var end: CGPoint? = nil
    private var clicks: Int = 0

    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        switch clicks {
        case 0:
            start = location
            clicks = 1
        case 1:
            end = location
            clicks = 2
        case 2:
            start = location
            end = nil
            clicks = 1
        default:
            start = nil
            end = nil
            clicks = 0
        }

        return nil
    }

    mutating func drawPreview(in ctx: CGContext, mouse: CGPoint, context: CanvasToolContext) {
        guard let start = start else { return }
        let isDarkMode = NSAppearance.currentDrawing().bestMatch(from: [.darkAqua, .aqua]) == .darkAqua

        // Determine current end point
        let currentEnd = (clicks >= 2 ? end ?? mouse : mouse)

        // Draw the main line with rounded caps
        ctx.setStrokeColor(NSColor(isDarkMode ? .white : .black).cgColor)
        ctx.setLineWidth(1)
        ctx.setLineCap(.round)
        ctx.move(to: start)
        ctx.addLine(to: currentEnd)
        ctx.strokePath()

        // Draw midpoint and endpoint ticks
        let dx = currentEnd.x - start.x
        let dy = currentEnd.y - start.y
        let distance = hypot(dx, dy)
        let distanceMM = distance / 10.0

        let mid = CGPoint(x: (start.x + currentEnd.x) / 2,
                          y: (start.y + currentEnd.y) / 2)

        let rawPerp = CGPoint(x: -dy, y: dx)
        let length = hypot(rawPerp.x, rawPerp.y)
        guard length > 0 else { return }
        let unitPerp = CGPoint(x: rawPerp.x / length, y: rawPerp.y / length)

        let tickLength: CGFloat = 4
        let drawTick: (CGPoint) -> Void = { center in
            let tickStart = CGPoint(x: center.x - unitPerp.x * tickLength,
                                    y: center.y - unitPerp.y * tickLength)
            let tickEnd = CGPoint(x: center.x + unitPerp.x * tickLength,
                                  y: center.y + unitPerp.y * tickLength)
            ctx.move(to: tickStart)
            ctx.addLine(to: tickEnd)
            ctx.strokePath()
        }

        drawTick(mid)
        drawTick(start)
        drawTick(currentEnd)

        // Draw measurement label
        let labelText: String = distanceMM < 1
            ? String(format: "%.2f mm", distanceMM)
            : String(format: "%.1f mm", distanceMM)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium),
            .foregroundColor: NSColor(isDarkMode ? .white : .black)
        ]
        let text = NSAttributedString(string: labelText, attributes: attributes)
        let textSize = text.size()

        var labelOffsetDir = unitPerp
        if labelOffsetDir.y > 0 {
            labelOffsetDir = CGPoint(x: -labelOffsetDir.x, y: -labelOffsetDir.y)
        }

        let offsetDistance: CGFloat = 16
        let labelCenter = CGPoint(
            x: mid.x + labelOffsetDir.x * offsetDistance,
            y: mid.y + labelOffsetDir.y * offsetDistance
        )

        let drawPoint = CGPoint(
            x: labelCenter.x - textSize.width / 2,
            y: labelCenter.y - textSize.height / 2
        )

        text.draw(at: drawPoint)
    }
}
