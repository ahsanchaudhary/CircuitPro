//
//  LineTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

struct LineTool: CanvasTool {
    var id = "line"
    var symbolName = AppIcons.line
    var label = "Line"

    private var start: CGPoint?

    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        if let s = start {
            defer { start = nil }
            let prim = LinePrimitive(
                uuid: UUID(),
                start: s,
                end: location,
                strokeWidth: 1,
                color: .init(color: .blue)
            )
            return .primitive(.line(prim))
        } else {
            start = location
            return nil
        }
    }

    mutating func drawPreview(in ctx: CGContext, mouse: CGPoint, context: CanvasToolContext) {
        guard let s = start else { return }
        ctx.saveGState()
        ctx.setStrokeColor(NSColor(.blue).cgColor)
        ctx.setLineWidth(1)
        ctx.setLineDash(phase: 0, lengths: [4])
        ctx.move(to: s)
        ctx.addLine(to: mouse)
        ctx.strokePath()
        ctx.restoreGState()
    }
}
