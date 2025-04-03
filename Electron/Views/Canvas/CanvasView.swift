
import SwiftUI

struct CanvasView<Content: View>: View {
    let content: () -> Content
    @State private var scrollData = ScrollData(size: .zero, visible: .zero)
    @State private var backgroundStyle: BackgroundStyle = .dotted
    @State private var enableCrosshair: Bool = false

    // States for magnification
    @State private var scale: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            CanvasContentView(backgroundStyle: $backgroundStyle,
                              enableCrosshair: $enableCrosshair,
                              content: content)
                // Apply zoom effect using the computed anchor from scroll data.
                .scaleEffect(scale, anchor: computedAnchor)
        }
        // Use a custom ScrollData type to track both the content size and visible rect.
        .onScrollGeometryChange(for: ScrollData.self) { geometry in
            ScrollData(size: geometry.contentSize, visible: geometry.visibleRect)
        } action: { oldValue, newValue in
            if oldValue != newValue {
                scrollData = newValue
                print("ScrollData updated: \(newValue)")
            }
        }
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastMagnification
                    scale *= delta
                    // Clamp the scale between 0.5 and 2.0
                    scale = min(max(scale, 0.5), 2.0)
                    lastMagnification = value
                }
                .onEnded { _ in
                    lastMagnification = 1.0
                }
        )
        .overlay(alignment: .bottomTrailing) {
            Text("Visible: \(scrollData.visible.debugDescription)")
                .padding()
                .background(Color.gray.opacity(0.7))
                .foregroundColor(.white)
        }
    }

    /// Compute the anchor point from the visible rect center relative to the content size.
    /// This anchor is used by scaleEffect to zoom from the point currently in view.
    private var computedAnchor: UnitPoint {
        guard scrollData.size.width > 0, scrollData.size.height > 0 else { return .center }
        let x = scrollData.visible.midX / scrollData.size.width
        let y = scrollData.visible.midY / scrollData.size.height
        return UnitPoint(x: x, y: y)
    }

    struct ScrollData: Equatable {
        let size: CGSize
        let visible: CGRect
    }
}



// Preview
#Preview {
    CanvasView {
        Text("Center of Canvas")
            .position(x: 1000, y: 1000) // Placed in the middle
    }
}

