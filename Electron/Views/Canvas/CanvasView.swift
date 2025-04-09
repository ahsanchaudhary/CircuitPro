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
    
    @Environment(\.canvasManager) var canvasManager
    
    let content: () -> Content


    // Same state variables as before...
    @State private var scrollData: ScrollData = .empty

    @State private var gestureZoom: CGFloat = 1.0
    
    @State private var position = ScrollPosition(edge: .top)

    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical]) {
                CanvasBackgroundView()
                   
                    .frame(width: canvasManager.canvasSize.width, height: canvasManager.canvasSize.height)
                    .transformEffect(
                        .identity
                            .scaledBy(x: canvasManager.zoom * gestureZoom, y: canvasManager.zoom * gestureZoom)
                    )
            }
            .scrollPosition($position)
            .scrollDisabled(true)

            ScrollView([.horizontal, .vertical]) {
                ZStack {
                    
                    
                    content()
                    
                    
                }
                
                .frame(width: canvasManager.canvasSize.width * canvasManager.zoom, height: canvasManager.canvasSize.height * canvasManager.zoom)
                .transformEffect(
                    .identity
                        .scaledBy(x: canvasManager.zoom * gestureZoom, y: canvasManager.zoom * gestureZoom)
                )
            }
           
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
                position.scrollTo(point: CGPoint(x: scrollData.contentOffset.x, y: scrollData.contentOffset.y + scrollData.contentInsets.top))
            })

        }
        .overlay(alignment: .center) {
            Text("\(scrollData)")
                .background(Color.gray.opacity(0.3))
                .zIndex(10000)
        }
        .gesture(
            MagnifyGesture()
                .onChanged { value in
                    let newScale = canvasManager.zoom * value.magnification
                    let clampedScale = min(max(newScale, 0.5), 2.0)
                    gestureZoom = clampedScale / canvasManager.zoom
                }
                .onEnded { value in
                    canvasManager.zoom = min(max(canvasManager.zoom * value.magnification, 0.5), 2.0)
                    gestureZoom = 1.0
                }
            
        )
      
   
    }
    
    
  
}



#Preview {
    CanvasView {
        Text("hello canvas")
            .position(x: 1000, y: 1000)
    } 
}
