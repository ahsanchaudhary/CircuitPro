import SwiftUI

struct CanvasBackgroundView: View {

    
    @Environment(\.canvasManager) var canvasManager
    
    var body: some View {
        ZStack {
            // Background layer (dotted or grid)
            switch canvasManager.backgroundStyle {
            case .dotted:
                DottedLayerView()
                    
            case .grid:
                GridLayerView()
            }
//            DrawingSheetView()

            // Show crosshairs only if enabled
            if canvasManager.enableCrosshair && canvasManager.selectedLayoutTool == .cursor {
                CrosshairsView()
                    .position(canvasManager.canvasMousePosition)
               

            
            }
            // Mouse tracking overlay
            MouseTrackingView { newLocation in
                canvasManager.mouseLocation = newLocation
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
            .background(Color.clear)
          
           
        }

      

    }
}
