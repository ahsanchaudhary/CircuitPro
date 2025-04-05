//
//  LayoutToolbarView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI
struct LayoutToolbarView: View {
    // Define the tools for the layout toolbar.
    enum LayoutTools: String, CaseIterable, ToolbarTool {
        case cursor = "cursorarrow"
        case trace = "line.diagonal.arrow"
        case via = "smallcircle.filled.circle.fill"
        case zone = "inset.filled.square.dashed"
        case line = "line.diagonal"
        case arc = "wave.3.up"
        case rectangle = "rectangle"
        case circle = "circle"
        case polygon = "hexagon"
        
        // Conform to ToolbarTool by specifying the default cursor.
        static var defaultTool: LayoutTools { .cursor }
    }
    
    var body: some View {
        ToolbarView<LayoutTools>(
            tools: LayoutTools.allCases,
            // Insert a divider after the cursor and zone tools.
            dividerAfter: { tool in
                tool == .cursor || tool == .zone
            },
            imageName: { $0.rawValue },
            onToolSelected: { tool in
                // Handle layout tool selection.
                print("Layout tool selected:", tool)
            }
        )
    }
}

#Preview {
    LayoutToolbarView()
}
