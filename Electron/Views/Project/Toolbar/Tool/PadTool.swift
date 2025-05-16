//
//  PinTool 2.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/16/25.
//

import SwiftUI

struct PadTool: CanvasTool {
    var id = "pad"
    var symbolName = AppIcons.pad
    var label = "Pad"

    mutating func handleTap(at location: CGPoint,
                            context: CanvasToolContext) -> CanvasElement? {
        let number = context.existingPinCount + 1
        let pin = Pin(name: "",
                      number: number,
                      position: location,
                      type: .unknown,
                      lengthType: .long)
        return .pin(pin)
    }

    mutating func drawPreview(in ctx: CGContext,
                              mouse: CGPoint,
                              context: CanvasToolContext)
    {
        let previewPin = Pin(name: "",
                             number: context.existingPinCount + 1,
                             position: mouse,
                             type: .unknown,
                             lengthType: .long)

        previewPin.draw(in: ctx,
                        showText: true,      // want number/label during preview?
                        highlight: false)   // no selection halo for preview
    }
}



