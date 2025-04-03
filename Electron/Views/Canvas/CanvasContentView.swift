import SwiftUI

struct CanvasContentView<Content: View>: View {
    @Binding var backgroundStyle: BackgroundStyle
    @Binding var enableCrosshair: Bool
    
    let content: () -> Content

    @State private var mouseLocation: CGPoint = .zero
    let gridSpacing: CGFloat = 20.0

    var body: some View {
        ZStack {
            // Background layer (dotted or grid)
            switch backgroundStyle {
            case .dotted:
                DottedLayerView()
            case .grid:
                GridLayerView()
            }

            // Your custom content
            content()

            // Show crosshairs only if enabled
            if enableCrosshair {
                CrosshairsView()
                    .position(
                        x: round(mouseLocation.x / gridSpacing) * gridSpacing,
                        y: round(mouseLocation.y / gridSpacing) * gridSpacing
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
        .frame(width: 3000, height: 3000)
    }
}
