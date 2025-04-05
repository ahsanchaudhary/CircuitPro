//
//  SchematicToolbar.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI

struct SchematicToolbarView: View {
    // Define the tools for the schematic toolbar.
    enum SchematicTools: String, CaseIterable, ToolbarTool {
        case cursor = "cursorarrow"
        case wire = "line.diagonal"
        case bus = "bus"
        case wiretobus = "xmark"
        case noconnect = "circle.fill"
        
        // Conform to ToolbarTool by specifying the default cursor.
        static var defaultTool: SchematicTools { .cursor }
    }
    
    var body: some View {
        ToolbarView<SchematicTools>(
            tools: SchematicTools.allCases,
            // Insert a divider after the cursor tool.
            dividerAfter: { tool in
                tool == .cursor
            },
            imageName: { $0.rawValue },
            onToolSelected: { tool in
                // Handle schematic tool selection.
                print("Schematic tool selected:", tool)
            }
        )
    }
}


#Preview {
    SchematicToolbarView()
}
