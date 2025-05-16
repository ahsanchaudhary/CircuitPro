//  PadTool.swift
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
      
        let pad = Pad(
            number: 0,
            position: location,
            shape: .rect(width: 5, height: 10),
            type: .surfaceMount,
            drillDiameter: nil
        )
        return .pad(pad)
    }

    mutating func drawPreview(in ctx: CGContext,
                              mouse: CGPoint,
                              context: CanvasToolContext)
    {
        let previewPad = Pad(
            number: 0,
            position: mouse,
            shape: .rect(width: 5, height: 10),
            type: .surfaceMount,
            drillDiameter: nil
        )
        previewPad.draw(in: ctx, highlight: false)
    }
}
