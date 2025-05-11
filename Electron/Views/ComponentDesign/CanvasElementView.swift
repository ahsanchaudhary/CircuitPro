//
//  CanvasElementView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/3/25.
//
import SwiftUI

struct CanvasElementView: View {
    
    @Binding var element: CanvasElement
    let isSelected: Bool
    let selectedPrimitiveID: UUID?
    let offset: CGSize
    let alpha: CGFloat

    var body: some View {
        switch element {
        case .primitive(let p):
            if selectedPrimitiveID == p.id {
                p.renderWithHandles(
                    isSelected: isSelected,
                    primitive:    p,
                    dragOffset: offset,
                    opacity:    alpha
                )
            } else {
                p.renderWithSelection(isSelected: isSelected, dragOffset: offset, opacity: alpha)
               
            }

        case .pin(let pin):
            PinView(
                pin: pin,
                isSelected: isSelected,
                offset: offset,
                opacity: alpha
            )
        case .pad(let pad):
            PadView(pad: pad, isSelected: isSelected, offset: offset, opacity: alpha)
        case .layeredPrimitive(let lp):
            Rectangle()
                .frame(width: 50, height: 50)
        }
    }
}
