//
//  Layout.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//

import SwiftUI
import SwiftData

@Model
final class Layout {
    var title: String
    var data: Data
    var timestamps: TimeStamps

    var project: Project

    init(title: String, data: Data, project: Project) {
        self.title = title
        self.data = data
        self.project = project
        self.timestamps = TimeStamps()
    }
}
