//
//  PadTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/7/25.
//

import SwiftUI

struct PadTool: CanvasTool {
    var id = "pad"
    var symbolName = AppIcons.pad
    var label = "Pad"
    
    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        let number = context.existingPinCount + 1
        let pad = Pad(number: 0, position: location.asSDPoint)
        return .pad(pad)
    }

    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> some View {
        PadView(pad: Pad(number: 0, position: mousePosition.asSDPoint, shape: .rect(width: 5, height: 10)))
            .allowsHitTesting(false)
    }
    
    
}

