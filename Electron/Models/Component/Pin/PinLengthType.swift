//
//  PinLengthType.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

enum PinLengthType: String, Codable, CaseIterable, Identifiable {
    case short
    case long

    var id: String { rawValue }
}
