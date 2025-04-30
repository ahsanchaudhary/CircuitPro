//
//  Symbol.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//

import SwiftUI
import SwiftData
import Foundation

@Model
class Symbol {

    @Attribute(.unique)
    var uuid: UUID
    @Attribute(.unique)
    var name: String
    
    
    var component: Component?
    
    var primitives: [GraphicPrimitiveType]
    
    var pins: [Pin]

    init(uuid: UUID = UUID(), name: String, component: Component? = nil, primitives: [GraphicPrimitiveType] = [], pins: [Pin] = []) {
self.uuid = uuid
        self.name = name
        self.component = component
        self.primitives = primitives
        self.pins = pins
    }
}


