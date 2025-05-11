//
//  LayerTypeListView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/9/25.
//

import SwiftUI

struct LayerTypeListView: View {
    
    @State private var selectedLayerType: LayerType?
    
    var body: some View {
        StageSidebarView {
            Text("Layers")
                .font(.headline)
        } content: {
     
                List(LayerType.usedInFootprints, id: \.self, selection: $selectedLayerType) { layerType in
               
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(layerType.defaultColor)
                            Text(layerType.rawValue)
                        
                    }
                        .disableAnimations()
                }
                .scrollContentBackground(.hidden)
            
        }

    }
}

#Preview {
    LayerTypeListView()
}
