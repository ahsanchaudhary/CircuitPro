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
    
    var components: [Component]

    init(uuid: UUID = UUID(), name: String, footprintType: FootprintType = .throughHole, components: [Component] = []) {
        self.uuid = uuid
        self.name = name
        self.footprintType = footprintType
        self.components = components
    }
}
