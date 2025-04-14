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

    init(uuid: UUID = UUID(), name: String) {
        self.uuid = uuid
        self.name = name
    }
}
