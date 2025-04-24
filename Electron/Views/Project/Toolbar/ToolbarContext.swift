//
//  ToolbarContext.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI


protocol ToolbarContext: Hashable & CaseIterable {
  /// The `cursor` case for this tool context
  static var cursorCase: Self { get }
}

extension ToolbarContext {
  /// The default tool (always cursor)
  static var defaultTool: Self { cursorCase }

  /// A list of all tools with cursor placed at the top
  static var allWithCursorFirst: [Self] {
    [cursorCase] + allCases.filter { $0 != cursorCase }
  }
}