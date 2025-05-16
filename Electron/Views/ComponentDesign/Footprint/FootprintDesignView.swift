//
//  FootprintDesignView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/7/25.
//

import SwiftUI

struct FootprintDesignView: View {
    @Environment(CanvasManager.self) private var canvasManager
    @Environment(\.componentDesignManager) private var componentDesignManager
    
    var body: some View {
        @Bindable var bindableComponentDesignManager = componentDesignManager

        CoreGraphicsCanvas(manager: canvasManager, elements: $bindableComponentDesignManager.footprintElements, selectedIDs: $bindableComponentDesignManager.selectedFootprintElementIDs, selectedTool: $bindableComponentDesignManager.selectedFootprintTool)
        
        .clipAndStroke(with: .rect(cornerRadius: 20))
        .overlay {
            CanvasOverlayView(enableComponentDrawer: false) {
                FootprintDesignToolbarView()
            }
            .padding(10)
        }
    }
}

