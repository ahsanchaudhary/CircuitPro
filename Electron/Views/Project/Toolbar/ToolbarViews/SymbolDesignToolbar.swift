//
//  SymbolDesignToolbar.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI

enum SymbolDesignToolbar: Hashable, ToolbarContext {
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