//
//  SymbolDesignToolbarView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/19/25.
//
import SwiftUI

struct SymbolDesignToolbarView: View {
    
    @Environment(\.componentDesignManager) private var componentDesignManager
   
    
    var body: some View {
        ToolbarView<SymbolDesignToolbar>(
            tools: SymbolDesignToolbar.allCases,
            // Insert a divider after the cursor and zone tools.
            dividerAfter: { tool in
                tool == .cursor
            },
            imageName: { $0.symbolName },
            onToolSelected: { tool in
                // Handle layout tool selection.
                print("Layout tool selected:", tool)
            
                componentDesignManager.selectedSymbolDesignTool = tool
                componentDesignManager.updateActiveTool()
            }
        )
    }
}
