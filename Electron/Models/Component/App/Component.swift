//
//  ComponentItem.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//


import SwiftData
import Foundation

@Model
class Component {

    @Attribute(.unique)
    var uuid: UUID
    @Attribute(.unique)
    var name: String
    

    @Relationship(deleteRule: .cascade, inverse: \Symbol.component)
    var symbol: Symbol?
    var footprints: [Footprint]

    var category: ComponentCategory?
    var properties: [ComponentProperty]

    init(uuid: UUID = UUID(), name: String, symbol: Symbol? = nil, footprints: [Footprint] = [], category: ComponentCategory? = nil, properties: [ComponentProperty] = []) {
        self.uuid = uuid
        self.name = name
        self.symbol = symbol
        self.footprints = footprints
        self.category = category
        self.properties = properties
    }
 
}



