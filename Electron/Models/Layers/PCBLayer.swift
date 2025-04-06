//
//  PCBLayers.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI
import SwiftData

@Model
final class PCBLayer {
    var type: PCBLayerType
    var layout: Layout?
    var color: SDColor
    
    var isHidden: Bool = false
    
    init(type: PCBLayerType, layout: Layout, color: SDColor = SDColor(color: .red)) {
        self.type = type
        self.layout = layout
        self.color = color
    }
}

extension PCBLayer {
    var colorBinding: Binding<Color> {
        Binding<Color>(
            get: { self.color.color },
            set: { newColor in
                self.color = SDColor(color: newColor)
            }
        )
    }
}


