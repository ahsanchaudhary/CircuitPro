//
//  Handle.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/15/25.
//


// Handle.swift
import CoreGraphics

struct Handle: Hashable {
    enum Kind: Hashable {
        case circleRadius
        case lineStart, lineEnd
        case rectTopLeft, rectTopRight,
                 rectBottomRight, rectBottomLeft
    }

    let kind: Kind
    let position: CGPoint
}
