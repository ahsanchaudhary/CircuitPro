//
//  GraphicsToolbar.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//

import SwiftUI

enum GraphicsToolbar: String, CaseIterable, Hashable {
  case line = "line.diagonal"
  case rectangle = "rectangle"
  case circle = "circle"

  var symbolName: String { rawValue }
  var label: String { rawValue.capitalized }
}
