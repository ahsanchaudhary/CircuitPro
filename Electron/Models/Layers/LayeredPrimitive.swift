//
//  LayeredPrimitive.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/7/25.
//
import SwiftUI

struct LayeredPrimitive: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var primitive: AnyPrimitive
    var layerType: LayerType
}
