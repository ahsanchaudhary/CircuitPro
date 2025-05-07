//
//  Footprint.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//
import SwiftUI
import SwiftData

@Model
class Footprint {

    @Attribute(.unique)
    var uuid: UUID
    var name: String
    
    var footprintType: FootprintType
    
    var layeredPrimitives: [LayeredPrimitive]
    
    var components: [Component]

    init(uuid: UUID = UUID(), name: String, footprintType: FootprintType = .throughHole, layeredPrimitives: [LayeredPrimitive], components: [Component] = []) {
        self.uuid = uuid
        self.name = name
        self.footprintType = footprintType
        self.layeredPrimitives = layeredPrimitives
        self.components = components
    }
}







