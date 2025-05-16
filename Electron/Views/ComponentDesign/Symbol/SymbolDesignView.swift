import SwiftUI

struct SymbolDesignView: View {
    
    @Environment(CanvasManager.self) private var canvasManager
    @Environment(\.componentDesignManager) private var componentDesignManager
    

    
    var body: some View {
        @Bindable var bindableComponentDesignManager = componentDesignManager
        CoreGraphicsCanvas(manager: canvasManager, elements: $bindableComponentDesignManager.symbolElements, selectedIDs: $bindableComponentDesignManager.selectedSymbolElementIDs, selectedTool: $bindableComponentDesignManager.selectedSymbolTool)
        
            .clipAndStroke(with: .rect(cornerRadius: 20))
            .overlay {
                CanvasOverlayView(enableComponentDrawer: false) {
                    SymbolDesignToolbarView()
                }
                .padding(10)
            }
    }
}

