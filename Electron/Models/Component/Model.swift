//
//  Model.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//

import SwiftUI
import SwiftData

@Model
class Model {

    var name: String
    var thumbnail: String?

    init(name: String, thumbnail: String? = nil) {
        self.name = name
        self.thumbnail = thumbnail
    }
}
