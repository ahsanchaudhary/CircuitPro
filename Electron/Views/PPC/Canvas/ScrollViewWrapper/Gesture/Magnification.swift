//
//  Magnification.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/9/25.
//

//  Magnification.swift
import CoreGraphics

public struct Magnification {

    /// Range from minimum to maximum magnification
    public let range: ClosedRange<CGFloat>

    /// Initial magnification, must be within the range
    public let initialValue: CGFloat

    /// Is magnification relative to the view frame or absolute to the content size
    public let isRelative: Bool

    public init(range: ClosedRange<CGFloat>, initialValue: CGFloat, isRelative: Bool) {
        self.range = range
        self.initialValue = initialValue
        self.isRelative = isRelative
    }
}
//EOF
