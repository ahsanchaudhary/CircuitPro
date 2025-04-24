//
//  GraphicsTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI


protocol GraphicsTool {
  associatedtype Preview: View

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType?
  
  @ViewBuilder
  func preview(mousePosition: CGPoint) -> Preview
}