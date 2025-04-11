//
//  SchematicToolbar.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI

// Define the tools for the schematic toolbar.
enum SchematicTools: String, CaseIterable, ToolbarTool {
    case cursor = "cursorarrow"
    case wire = "line.diagonal"
    case noconnect = "xmark"
    case junction = "circle.fill"
    
    // Conform to ToolbarTool by specifying the default cursor.
    static var defaultTool: SchematicTools { .cursor }
}


struct SchematicToolbarView: View {
    
    @Environment(\.canvasManager) var canvasManager
 
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
                canvasManager.selectedSchematicTool = tool
            }
        )
    }
}


#Preview {
    SchematicToolbarView()
}
