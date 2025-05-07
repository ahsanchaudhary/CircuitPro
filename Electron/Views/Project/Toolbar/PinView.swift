//
//  PinView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

struct PinView: View {
    var pin: Pin
    var isSelected: Bool = false
    var offset: CGSize = .zero
    var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            TextShape(text: pin.name, alignment: .trailing)
                .fill(.blue)
                .stroke(isSelected ? .blue.opacity(0.5) : .clear, lineWidth: 1)
                .opacity(opacity)
                .frame(width: 25, height: 50, alignment: .leading)
                .position(pin.position.cgPoint)
                .offset(offset)
                .offset(x: -pin.length - 15, y: -5)
            
            
            ForEach(pin.primitives, id: \.id) { primitive in
                primitive.renderWithSelection(
                    isSelected: isSelected,
                    dragOffset: offset,
                    opacity: opacity
                )
            }
            
            TextShape(text: pin.number.description, alignment: .leading)
            
                .fill(.blue)
                .stroke(isSelected ? .blue.opacity(0.5) : .clear, lineWidth: 1)
                .opacity(opacity)
                .frame(width: 25, height: 50, alignment: .leading)
  
                .position(pin.position.cgPoint)
            
                .offset(offset)
                .offset(x: 25, y: 0)
             
        }
    }
}
