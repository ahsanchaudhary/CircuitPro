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
    
    @Relationship(deleteRule: .cascade, inverse: \PCBLayer.layout)
    var layers: [PCBLayer] = []


    var project: Project?

    init(title: String, data: Data, project: Project) {
        self.title = title
        self.data = data
        self.project = project
        self.timestamps = TimeStamps()
    }
}

extension Layout {
    func populateDefaultLayers() {
        for layerType in PCBLayerType.defaultLayerTypes {
            let layer = PCBLayer(
                type: layerType,
                layout: self,
                color: ColorEntity(color: layerType.defaultColor)
            )
            self.layers.append(layer)
        }
    }
}
