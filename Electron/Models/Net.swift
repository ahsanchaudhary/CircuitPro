//
//  Net.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI
import SwiftData


@Model
final class Net {

    var name: String
    var schematic: Schematic?
    var color: ColorEntity
    
    var isHidden: Bool = false
    
    init(name: String, schematic: Schematic, color: ColorEntity = ColorEntity(color: .red)) {
        self.name = name
        self.schematic = schematic
        self.color = color
    }
}

extension Net {
    var colorBinding: Binding<Color> {
        Binding<Color>(
            get: { self.color.color },
            set: { newColor in
                self.color = ColorEntity(color: newColor)
            }
        )
    }
}
