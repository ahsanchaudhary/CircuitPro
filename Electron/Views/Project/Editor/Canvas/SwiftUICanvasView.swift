
import SwiftUI

struct SwiftUICanvasView<Content: View>: View {

    let content: () -> Content


    // Same state variables as before...
    @State private var scrollData: ScrollData = .empty

    @State private var gestureZoom: CGFloat = 1.0
    @State private var zoom: CGFloat = 1.0
    
    @State private var position = ScrollPosition(x: 0, y: 0)
    @State private var offset: CGSize = .zero

    var body: some View {

            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    CanvasBackgroundView()

                    
                    content()
                      

                    
                }
                .frame(width: 3000, height: 3000)
                .scaleEffect(zoom * gestureZoom, anchor: computedAnchor)
                .offset(x: offset.width, y: offset.height)
                .offset(computedOffset)
               
            }
            .scrollPosition($position)
           
            .scrollContentBackground(.hidden)
            .onScrollGeometryChange(for: ScrollData.self, of: { scrollGeometry in
                ScrollData(
                    contentOffset: scrollGeometry.contentOffset,
                    contentSize: scrollGeometry.contentSize,
                    contentInsets: scrollGeometry.contentInsets,
                    containerSize: scrollGeometry.containerSize,
                    bounds: scrollGeometry.bounds,
                    visibleRect: scrollGeometry.visibleRect
                )
            }, action: { oldValue, newValue in
                scrollData = newValue
             
            })

    
            .overlay(alignment: .bottom) {
                VStack {
                    Text("\(scrollData)")
   
                    Text("Computed Anchor: \(computedAnchor.x), \(computedAnchor.y)")
                    Text(gestureZoom.description)
                    Text(zoom.description)
                }
                .background(Color.gray.opacity(0.3))
                .zIndex(10000)
            }
        .gesture(
            MagnifyGesture()
                .onChanged { value in
                    let newScale = zoom * value.magnification
                    let clampedScale = min(max(newScale, 0.5), 2.0)
                    gestureZoom = clampedScale / zoom
                }
                .onEnded { value in
                   
                    zoom = min(max(zoom * value.magnification, 0.5), 2.0)
                    
                    gestureZoom = 1.0
         
                }
            
        )
      
   
    }
    
    private func computeOffset() -> CGSize {
        let effectiveZoom = zoom * gestureZoom
   
        let t = effectiveZoom - 1.0
        return CGSize(width: 300 * t, height: (200 - scrollData.contentInsets.top) * t)
    }
    
    private var computedOffset: CGSize {
        let effectiveZoom = zoom * gestureZoom
   
        let t = effectiveZoom - 1.0
        return CGSize(width: 300 * t, height: (200 - scrollData.contentInsets.top) * t)
    }




    
    private var computedAnchor: UnitPoint {
          guard scrollData.contentSize.width > 0, scrollData.contentSize.height > 0 else { return .center }
          let x = scrollData.visibleRect.midX / scrollData.contentSize.width
          let y = scrollData.visibleRect.midY / scrollData.contentSize.height
          return UnitPoint(x: x, y: y)
      }
  
}



#Preview {
    SwiftUICanvasView {
        Text("hello canvas")
            .position(x: 1000, y: 1000)
    } 
}
