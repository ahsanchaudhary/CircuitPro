//
//  AnyGraphicsTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI


enum AnyGraphicsTool {
  case line(LineTool)
  case rectangle(RectangleTool)
  case circle(CircleTool)

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    switch self {
    case .line(var tool): let result = tool.handleTap(at: location); self = .line(tool); return result
    case .rectangle(var tool): let result = tool.handleTap(at: location); self = .rectangle(tool); return result
    case .circle(var tool): let result = tool.handleTap(at: location); self = .circle(tool); return result
    }
  }

  @ViewBuilder
  func preview(mousePosition: CGPoint) -> some View {
    switch self {
    case .line(let tool): tool.preview(mousePosition: mousePosition)
    case .rectangle(let tool): tool.preview(mousePosition: mousePosition)
    case .circle(let tool): tool.preview(mousePosition: mousePosition)
    }
  }
}