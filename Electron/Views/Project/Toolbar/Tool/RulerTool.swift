//
//  RulerTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/18/25.
//
import SwiftUI

struct RulerTool: CanvasTool {
    var id: String = "ruler"
    var symbolName: String = AppIcons.ruler
    var label: String = "Ruler"

    private var start: CGPoint? = nil
    private var end: CGPoint? = nil
    private var clicks: Int = 0

    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        clicks += 1

        switch clicks {
        case 1:
            start = location
        case 2:
            end = location
        case 3:
            // Reset and hide ruler
            start = nil
            end = nil
            clicks = 0
        default:
            break
        }

        return nil  // This tool does not create persistent elements
    }

    mutating func drawPreview(in ctx: CGContext, mouse: CGPoint, context: CanvasToolContext) {
        guard let start = start else { return }

        let currentEnd = (clicks >= 2 ? end ?? mouse : mouse)


        ctx.setStrokeColor(NSColor.systemBlue.cgColor)
        ctx.setLineWidth(1)
        ctx.move(to: start)
        ctx.addLine(to: currentEnd)
        ctx.strokePath()

        // Draw distance
        let dx = currentEnd.x - start.x
        let dy = currentEnd.y - start.y
        let distance = hypot(dx, dy)
        let label = String(format: "%.2f", distance)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 10),
            .foregroundColor: NSColor.gray
        ]
        let attr = NSAttributedString(string: label, attributes: attributes)
        let mid = CGPoint(x: (start.x + currentEnd.x) / 2, y: (start.y + currentEnd.y) / 2)
        attr.draw(at: CGPoint(x: mid.x + 5, y: mid.y + 5))
    }
}
