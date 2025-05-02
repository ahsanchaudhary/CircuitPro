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
            Text(pin.name)
                .opacity(opacity)
                .adjustedFontForMagnification(baseSize: 14)
                .position(pin.position.cgPoint)
                .offset(offset)
                .offset(x: -pin.length - 15, y: 0)
                
            
            ForEach(pin.primitives, id: \.id) { primitive in
                primitive.renderWithSelection(
                    isSelected: isSelected,
                    dragOffset: offset,
                    opacity: opacity
                )
            }
            Text(pin.number.description)
                .opacity(opacity)
                .adjustedFontForMagnification(baseSize: 14)
                .position(pin.position.cgPoint)
                .offset(offset)
                .offset(x: 15, y: 0)
        }
    }
}
