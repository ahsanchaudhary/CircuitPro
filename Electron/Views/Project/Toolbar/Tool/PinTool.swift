//
//  PinTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

struct PinTool: CanvasTool {
    var id = "pin"
    var symbolName = AppIcons.pin
    var label = "Pin"
    
    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        let number = context.existingPinCount + 1
        let pin = Pin(
            name: "",
            number: number,
            position: SDPoint(x: location.x, y: location.y),
            type: .unknown,
            lengthType: .long
        )
        return .pin(pin)
    }

    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> some View {
        PinView(pin: Pin(name: "", number: context.existingPinCount, position: mousePosition.asSDPoint, type: .unknown))
            .allowsHitTesting(false)
    }
    
    
}

