//
//  Pad.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/5/25.
//
import SwiftUI

struct Pad: Identifiable, Codable {
    var id: UUID = UUID()
    var number: Int
    var position: SDPoint
    var shape: PadShape = .rect(width: 1.0, height: 1.0)
    var padType: PadType = .surfaceMount
}
