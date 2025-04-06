//
//  Item.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import Foundation
import SwiftData

@Model
final class Project {
    var name: String
    var timestamps: Timestamps
    
    @Relationship(deleteRule: .cascade, inverse: \Schematic.project)
    var schematic: Schematic?
    
    @Relationship(deleteRule: .cascade, inverse: \Layout.project)
    var layout: Layout?

    init(name: String) {
        self.name = name
        self.timestamps = Timestamps()
    }
}


