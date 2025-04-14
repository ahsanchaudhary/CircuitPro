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
    var name: String
    
    var primitives: [GraphicPrimitiveType]

    init(uuid: UUID = UUID(), name: String, primitives: [GraphicPrimitiveType] = []) {
self.uuid = uuid
        self.name = name
        self.primitives = primitives
    }
}

