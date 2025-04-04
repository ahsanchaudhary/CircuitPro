
import SwiftUI
import SwiftUI

import SwiftUI

// MARK: - Full ScrollData
struct ScrollData: Equatable {
    let contentOffset: CGPoint
    let contentSize: CGSize
    let contentInsets: EdgeInsets
    let containerSize: CGSize
    let bounds: CGRect
    let visibleRect: CGRect

    static let empty = ScrollData(
        contentOffset: .zero,
        contentSize: .zero,
        contentInsets: EdgeInsets(),
        containerSize: .zero,
        bounds: .zero,
        visibleRect: .zero
    )
}

struct CanvasView<Content: View>: View {
    let content: () -> Content
    
    
    
    @State var scrollData: ScrollData = .empty

    @State private var backgroundStyle: BackgroundStyle = .dotted
    @State private var enableCrosshair: Bool = false

    @State private var canvasSize: CGSize = CGSize(width: 3000, height: 3000)
    @State private var zoom: CGFloat = 0.5


    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack {
                content()
              
            }
            .scaleEffect(zoom, anchor: computedAnchor)
            .frame(
                          width: canvasSize.width * zoom,
                          height: canvasSize.height * zoom, // Multiply the height by zoom as well
                          alignment: .center
                      )
            
           
         
        }
        .defaultScrollAnchor(.center)
        .onScrollGeometryChange(for: ScrollData.self, of: { scrollGeometry in
            ScrollData(contentOffset: scrollGeometry.contentOffset, contentSize: scrollGeometry.contentSize, contentInsets: scrollGeometry.contentInsets, containerSize: scrollGeometry.containerSize, bounds: scrollGeometry.bounds, visibleRect: scrollGeometry.visibleRect)
        }, action: { oldValue, newValue in
            scrollData = newValue
        })
        .overlay(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Spacer()
                    Text("Zoom: \(zoom, specifier: "%.2f")")
                    Slider(value: $zoom, in: 0.1...5)
                }
                Text("\(scrollData)")
            }
            .padding(10)
        }
    }
    
    private var computedAnchor: UnitPoint {
          guard scrollData.contentSize.width > 0, scrollData.contentSize.height > 0 else { return .center }
          let x = scrollData.visibleRect.midX / scrollData.contentSize.width
          let y = scrollData.visibleRect.midY / scrollData.contentSize.height
          return UnitPoint(x: x, y: y)
      }
}


// Preview
#Preview {
    CanvasView {
        Text("Center of Canvas")
            .position(x: 1500, y: 1500) // Placed in the middle
    }
}

