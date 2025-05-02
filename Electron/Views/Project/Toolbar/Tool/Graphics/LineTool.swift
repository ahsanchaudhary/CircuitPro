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
        handleTap(at: location)
    }
    
    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> some View {
        preview(mousePosition: mousePosition)
    }

    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        if let s = start {
            defer { start = nil }
            let prim = GraphicPrimitiveType.line(
                .init(strokeWidth: 1,
                      color: .init(color: .orange),
                      start: s,
                      end: location)
            )
            return .primitive(prim)
        } else {
            start = location
            return nil
        }
    }
    
    func preview(mousePosition: CGPoint) -> some View {
        Group {
            if let s = start {
                Path { $0.move(to: s); $0.addLine(to: mousePosition) }
                    .stroke(.orange, style: .init(lineWidth: 1, dash: [4]))
                    .allowsHitTesting(false)
            }
        }
    }
}
