//
//  ColorEntity.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//


import SwiftUI

struct SDColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    init(color: Color) {
        let nsColor = NSColor(color)
        // Convert to device RGB colorspace so getRed(_:green:blue:alpha:) can work.
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else {
            // Fallback to default values if conversion fails.
            self.red = 1.0
            self.green = 0.0
            self.blue = 0.0
            self.alpha = 1.0
            return
        }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        rgbColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.alpha = Double(a)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
