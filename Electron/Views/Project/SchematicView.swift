//
//  SchematicView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//

import SwiftUI

struct Symbol: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
}

struct SchematicView: View {
    @State private var symbols: [Symbol] = [
        Symbol(x: 1500, y: 1500),
        Symbol(x: 1400, y: 1400)
    ]
    
    var body: some View {
   
            CanvasView {
                ForEach(symbols.indices, id: \.self) { index in
                    DraggableSymbol(position: $symbols[index])
                    
                }
            }
     
   
        
    }
}

struct DraggableSymbol: View {
    @Binding var position: Symbol
    @State private var dragOffset = CGSize.zero

    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 30, height: 30)
            .position(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
         
            .gesture(
                DragGesture(coordinateSpace: .named("canvas"))
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        position.x += value.translation.width
                        position.y += value.translation.height
                        dragOffset = .zero
                    }
            )
        
    }
}


#Preview {
    SchematicView()
}
