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
    var timestamps: Timestamps
    
    @Relationship(deleteRule: .cascade, inverse: \Layer.layout)
    var layers: [Layer] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Via.layout)
    var vias: [Via] = []


    var project: Project?

    init(title: String, data: Data, project: Project) {
        self.title = title
        self.data = data
        self.project = project
        self.timestamps = Timestamps()
    }
}

extension Layout {
    func populateDefaultLayers() {
        for layerType in LayerType.defaultLayerTypes {
            let layer = Layer(
                type: layerType,
                layout: self,
                color: SDColor(color: layerType.defaultColor)
            )
            self.layers.append(layer)
        }
    }
}
