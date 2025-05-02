//
//  CursorTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//


import SwiftUI

struct CursorTool: CanvasTool {
    var id = "cursor"
    var symbolName = AppIcons.cursor
    var label = "Select"

    // Required method — context-aware version
    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        handleTap(at: location)
    }

    // Optional simplified version
    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        // No elements created on tap
        return nil
    }

    // Required method — context-aware preview
    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> some View {
        preview(mousePosition: mousePosition)
    }

    // Optional simplified version
    func preview(mousePosition: CGPoint) -> some View {
        EmptyView()
    }
}
