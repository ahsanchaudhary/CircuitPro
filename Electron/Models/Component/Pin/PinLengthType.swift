//
//  PinLengthType.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

enum PinLengthType: String, Displayable {
    case short
    case long

    var label: String {
        switch self {
        case .short:
            return "Short"
        case .long:
            return "Long"
        }
    }
}
