import SwiftUI

enum BackgroundStyle {
    case dotted
    case grid
}
struct CanvasView<Content: View>: View {
    let content: () -> Content
    
    @State private var zoomLevel: CGFloat = 1.0
    @State private var backgroundStyle: BackgroundStyle = .dotted
    @State private var enableCrosshair: Bool = true

    var body: some View {
        ZoomableNSScrollView(zoomLevel: $zoomLevel) {
            CanvasContentView(backgroundStyle: $backgroundStyle, enableCrosshair: $enableCrosshair,
                              zoomLevel: zoomLevel,
                              content: content)
        }
        .overlay(alignment: .bottom) {
            HStack {
                ZoomControlView(zoom: $zoomLevel)
                Spacer()
                CanvasControlView(enableCrosshair: $enableCrosshair, backgroundStyle: $backgroundStyle)
            }
            .padding()
            
        }
    }
}




#Preview {
    CanvasView {
        Text("Hello, World!")
            .position(x: 1000, y: 1000)
    }
}
