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
    
    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        let pin = Pin(
            number: 0,
            position: SDPoint(x: location.x, y: location.y),
            type: .unknown,
            lengthType: .long
        )
        return .pin(pin)
    }
    func preview(mousePosition: CGPoint) -> some View {
        PinView(pin: Pin(number: 0, position: mousePosition.asSDPoint, type: .unknown))
            .allowsHitTesting(false)
    }
    
    
}

