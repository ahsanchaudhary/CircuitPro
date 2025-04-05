import SwiftUI

struct CanvasContentView<Content: View>: View {

    
    @Environment(\.canvasManager) var canvasManager
    
    let content: () -> Content

    @State private var mouseLocation: CGPoint = .zero
    let gridSpacing: CGFloat = 20.0

    var body: some View {
        ZStack {
            // Background layer (dotted or grid)
            switch canvasManager.backgroundStyle {
            case .dotted:
                DottedLayerView()
                    
            case .grid:
                GridLayerView()
            }

        
            content()

            // Show crosshairs only if enabled
            if canvasManager.enableCrosshair {
                CrosshairsView()
                    .position(
                        x: canvasManager.enableSnapping
                            ? round(mouseLocation.x / gridSpacing) * gridSpacing
                            : mouseLocation.x,
                        y: canvasManager.enableSnapping
                            ? round(mouseLocation.y / gridSpacing) * gridSpacing
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
        .coordinateSpace(name: "canvas")
      

    }
}
