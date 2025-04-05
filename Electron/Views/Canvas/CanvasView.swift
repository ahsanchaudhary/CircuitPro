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

struct CanvasView<Content: View, Overlay: View>: View {
    
    @Environment(\.canvasManager) var canvasManager
    
    let content: () -> Content
    let overlay: () -> Overlay

    // Same state variables as before...
    @State private var scrollData: ScrollData = .empty
    @State private var canvasSize: CGSize = CGSize(width: 3000, height: 3000)
    @State private var zoom: CGFloat = 1.0
    @State private var gestureZoom: CGFloat = 1.0

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack {
                CanvasContentView {
                    content()
                }
             
            }
            .padding(10)
            .border(Color.gray.opacity(0.1), width: 1)
            .frame(width: canvasSize.width, height: canvasSize.height)
            .transformEffect(
                .identity
                    .scaledBy(x: zoom * gestureZoom, y: zoom * gestureZoom)
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
                    let newScale = zoom * value.magnification
                    let clampedScale = min(max(newScale, 0.5), 2.0)
                    gestureZoom = clampedScale / zoom
                }
                .onEnded { value in
                    zoom = min(max(zoom * value.magnification, 0.5), 2.0)
                    gestureZoom = 1.0
                }
        )
        .overlay(alignment: .bottom) {
            VStack {
                HStack {
                    ZoomControlView(zoom: $zoom)
                    Spacer()
                    contentDrawerButton

                    Spacer()
                    CanvasControlView()
                }
              
                overlay()
            }
            .padding(10)
        }
    }
    
    
    private var contentDrawerButton: some View {
        Button {
            withAnimation {
                canvasManager.showComponentDrawer.toggle()
            }
          
        } label: {
            HStack {
                if canvasManager.showComponentDrawer {
                    Image(systemName: "tray.full")
            
                }
                 Text("Component Drawer")
                   if !canvasManager.showComponentDrawer {
                       Image(systemName: "xmark")
                           
                   }
               }
            
        }
 
        .buttonStyle(.plain)
        .font(.callout)
        .fontWeight(.semibold)
        .padding(.vertical, 7.5)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}



#Preview {
    CanvasView {
        Text("hello canvas")
            .position(x: 1000, y: 1000)
    } overlay: {
        Text("This is overlay")
    }
}
