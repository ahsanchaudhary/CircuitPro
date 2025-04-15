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
    var name: String
    

    var symbol: Symbol
    var footprint: Footprint?
    var model: Model?
    
    var category: ComponentCategory?
    var properties: [ComponentProperty]

    init(uuid: UUID = UUID(), name: String, symbol: Symbol, footprint: Footprint? = nil, model: Model? = nil, category: ComponentCategory? = nil, properties: [ComponentProperty] = []) {
        self.uuid = uuid
        self.name = name
        self.symbol = symbol
        self.footprint = footprint
        self.model = model
        self.category = category
        self.properties = properties
    }
 
}



