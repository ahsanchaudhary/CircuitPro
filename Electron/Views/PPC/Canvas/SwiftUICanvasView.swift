//
//  SwiftUICanvasView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI



struct SwiftUICanvasView<Content: View>: View {
    let content: () -> Content
    
    @State var scrollData: ScrollData = .empty
    
    @State private var canvasSize: CGSize = CGSize(width: 3000, height: 3000)
    @State private var zoom: CGFloat = 1.0

    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack {
                
                content()

                
            }
            .border(.blue)
            .transformEffect(
                .identity
                    .scaledBy(x: zoom, y: zoom)
                    
            )
            .frame(width: canvasSize.width, height: canvasSize.height)
           


           
        }
        
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
                    Slider(value: $zoom, in: 1...2)
                                    
                    
                }
                Text("\(scrollData)")
                    .font(.callout)
                Text(computedAnchor.x.description + ", " + computedAnchor.y.description)

            }
            .padding(10)
        }
    }
    
    
    private var visibleAnchorPoint: CGPoint {
        CGPoint(x: computedAnchor.x * canvasSize.width,
                y: computedAnchor.y * canvasSize.height)
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
