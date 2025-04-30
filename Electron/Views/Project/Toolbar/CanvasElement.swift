//
//  CanvasElement.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

/// The one thing a tool can create.
enum CanvasElement: Identifiable {
  case primitive(GraphicPrimitiveType)
  case pin(Pin)

  var id: UUID {
    switch self {
    case .primitive(let p): return p.id
    case .pin(let pin):     return pin.id
    }
  }
}





