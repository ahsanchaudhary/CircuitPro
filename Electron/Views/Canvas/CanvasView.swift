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

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack {
                CanvasBackgroundView()
                content()
                
            
            }
//            .padding(10)
            .border(Color.gray.opacity(0.1), width: 1)
            .frame(width: canvasManager.canvasSize.width, height: canvasManager.canvasSize.height)
            .transformEffect(
                .identity
                    .scaledBy(x: canvasManager.zoom * gestureZoom, y: canvasManager.zoom * gestureZoom)
            )
        }
        .background(.white)
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
        .onTapGesture { location in
            print(location)
        }
   
    }
    
    
  
}



#Preview {
    CanvasView {
        Text("hello canvas")
            .position(x: 1000, y: 1000)
    } 
}
