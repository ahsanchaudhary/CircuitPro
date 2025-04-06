//
//  Schematic.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//
import SwiftUI
import SwiftData

@Model
final class Schematic {
    var title: String
    var data: Data
    var timestamps: Timestamps

    var project: Project?
    
    @Relationship(deleteRule: .cascade, inverse: \Net.schematic)
    var nets: [Net] = []

    init(title: String, data: Data, project: Project) {
        self.title = title
        self.data = data
        self.project = project
        self.timestamps = Timestamps()
    }
}
