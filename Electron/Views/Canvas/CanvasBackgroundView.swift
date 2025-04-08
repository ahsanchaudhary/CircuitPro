import SwiftUI

struct CanvasBackgroundView: View {

    
    @Environment(\.canvasManager) var canvasManager
    


    @State private var mouseLocation: CGPoint = .zero
    

    var body: some View {
        ZStack {
            // Background layer (dotted or grid)
            switch canvasManager.backgroundStyle {
            case .dotted:
                DottedLayerView()
                    
            case .grid:
                GridLayerView()
            }

            // Show crosshairs only if enabled
            if canvasManager.enableCrosshair {
                CrosshairsView()
                    .position(
                        x: canvasManager.enableSnapping
                        ? round(mouseLocation.x / canvasManager.gridSpacing) * canvasManager.gridSpacing
                            : mouseLocation.x,
                        y: canvasManager.enableSnapping
                        ? round(mouseLocation.y / canvasManager.gridSpacing) * canvasManager.gridSpacing
                            : mouseLocation.y
                    )

                // Mouse tracking overlay
                MouseTrackingView { newLocation in
                    self.mouseLocation = newLocation
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
                .background(Color.clear)
            }
          
           
        }

      

    }
}
