import SwiftUI

struct SymbolDesignView: View {
    
    @Environment(CanvasManager.self) private var canvasManager
    @Environment(\.componentDesignManager) private var componentDesignManager
    

    
    var body: some View {
        @Bindable var bindableComponentDesignManager = componentDesignManager
        @Bindable var bindableCanvasManager = canvasManager
        CoreGraphicsCanvas(elements: $bindableComponentDesignManager.symbolElements, selectedIDs: $bindableComponentDesignManager.selectedSymbolElementIDs, canvasBackgroundStyle: $bindableCanvasManager.backgroundStyle, selectedTool: $bindableComponentDesignManager.selectedSymbolTool)
        
            .clipAndStroke(with: .rect(cornerRadius: 20))
            .overlay {
                CanvasOverlayView(enableComponentDrawer: false) {
                    SymbolDesignToolbarView()
                }
                .padding(10)
            }
    }
}

