//
//  CanvasElement.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

/// The one thing a tool can create and can go on a canvas.
enum CanvasElement: Identifiable {
    case primitive(AnyPrimitive)
    case pin(Pin)
    case pad(Pad)
    case layeredPrimitive(LayeredPrimitive)

    var id: UUID {
        switch self {
        case .primitive(let p): return p.id
        case .pin(let pin):     return pin.id
        case .pad(let pad):     return pad.id
        case .layeredPrimitive(let lp): return lp.id
        }
    }
}
