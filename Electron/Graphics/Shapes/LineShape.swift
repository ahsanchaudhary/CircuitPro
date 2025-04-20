//
//  LineShape.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/16/25.
//


import SwiftUI

// MARK: - Custom Shape Structs

struct LineShape: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        
        return path
    }
}