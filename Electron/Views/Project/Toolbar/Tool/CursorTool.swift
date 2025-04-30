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

    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        // Return nil: don't create elements on tap
        return nil
    }

    // You handle crosshairs elsewhere, so this can be empty
    func preview(mousePosition: CGPoint) -> some View {
        EmptyView()
    }
}
