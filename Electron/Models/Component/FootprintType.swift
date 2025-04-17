//
//  FootprintType.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/17/25.
//

import SwiftUI

enum FootprintType: String, Codable, CaseIterable, Identifiable {
    case throughHole
    case surfaceMount
    case socketed
    case custom

    var id: String { rawValue }

    var label: String {
        switch self {
        case .throughHole: return "Through-Hole"
        case .surfaceMount: return "Surface Mount"
        case .socketed: return "Socketed"
        case .custom: return "Custom"
        }
    }
}

