//
//  SymbolDesignToolbarView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/19/25.
//
import SwiftUI

enum SymbolDesignToolbar: Hashable, ToolbarTool {
  case cursor
  case graphics(GraphicsToolbar)

  static var cursorCase: SymbolDesignToolbar { .cursor }

    static var allCases: [SymbolDesignToolbar] {
      [.cursor] + GraphicsToolbar.allCases.map { .graphics($0) }
    }


  var symbolName: String {
    switch self {
    case .cursor: return "cursorarrow"
    case .graphics(let tool): return tool.symbolName
    }
  }

  var label: String {
    switch self {
    case .cursor: return "Cursor"
    case .graphics(let tool): return tool.label
    }
  }
}


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
