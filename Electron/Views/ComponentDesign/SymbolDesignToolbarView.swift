//
//  SymbolDesignToolbarView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/19/25.
//
import SwiftUI



// Define the tools for the layout toolbar.
enum SymbolDesignTools: String, CaseIterable, ToolbarTool {
    case cursor = "cursorarrow"
    case line = "line.diagonal"
    case arc = "wave.3.up"
    case rectangle = "rectangle"
    case circle = "circle"
    case polygon = "hexagon"
    
    // Conform to ToolbarTool by specifying the default cursor.
    static var defaultTool: SymbolDesignTools { .cursor }
}

struct SymbolDesignToolbarView: View {
    
    @Environment(\.componentDesignManager) private var componentDesignManager
   
    
    var body: some View {
        ToolbarView<SymbolDesignTools>(
            tools: SymbolDesignTools.allCases,
            // Insert a divider after the cursor and zone tools.
            dividerAfter: { tool in
                tool == .cursor
            },
            imageName: { $0.rawValue },
            onToolSelected: { tool in
                // Handle layout tool selection.
                print("Layout tool selected:", tool)
                componentDesignManager.selectedSymbolDesignTool = tool
            }
        )
    }
}
