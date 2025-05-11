//
//  PadView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/7/25.
//
import SwiftUI

struct PadView: View {
    var pad: Pad
    var isSelected: Bool = false
    var offset: CGSize = .zero
    var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            ForEach(pad.primitives, id: \.id) { primitive in
                primitive.renderWithSelection(
                    isSelected: isSelected,
                    dragOffset: offset,
                    opacity: opacity
                )
            }
        }
    }
}
