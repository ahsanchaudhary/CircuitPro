//
//  SwiftUICanvasView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//


//
//  SwiftUICanvasView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI

struct CanvasView<Content: View>: View {

    let content: () -> Content


    // Same state variables as before...
    @State private var scrollData: ScrollData = .empty

    @State private var gestureZoom: CGFloat = 1.0
    @State private var zoom: CGFloat = 1.0
    
    @State private var position = ScrollPosition(x: 0, y: 0)

    var body: some View {

            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    CanvasBackgroundView()
                        .transformEffect(
                            .identity
                                .scaledBy(x:  gestureZoom, y:  gestureZoom)
                        )
                    
                    content()
                      
                        .transformEffect(
                            .identity
                                .scaledBy(x: zoom * gestureZoom, y: zoom * gestureZoom)
                        )
                    
                }
                .frame(width: 3000 * zoom, height: 3000 * zoom)
               
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
    
    private var computedAnchor: CGPoint {
        // Ensure we have valid dimensions first.
        guard scrollData.contentSize.width > 0, scrollData.contentSize.height > 0 else {
            // Fallback: center of the container or content if unavailable.
            return CGPoint(x: 1500 * zoom, y: 1500 * zoom)
        }
        // The visibleRect’s midpoints already represent the absolute coordinates.
        return CGPoint(
            x: scrollData.visibleRect.midX,
            y: scrollData.visibleRect.midY
        )
    }
   
  
}



#Preview {
    CanvasView {
        Text("hello canvas")
            .position(x: 1000, y: 1000)
    } 
}
