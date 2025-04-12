//
//  Unit.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI

// Define SI Prefixes
enum SIPrefix: String, CaseIterable, Codable {
    case none = ""
    case pico = "p"
    case nano = "n"
    case micro = "μ"
    case milli = "m"
    case kilo = "k"
    case mega = "M"
    case giga = "G"
}

// Define Base Units for electronic components
enum BaseUnit: String, CaseIterable, Codable {
    case ohm = "Ω"
    case farad = "F"      // Used for capacitance
    case henry = "H"
    case volt = "V"
    case ampere = "A"
    case watt = "W"
    case hertz = "Hz"
    case celsius = "°C"
    case percent = "%"    // Typically used for tolerance

    // Computed property to indicate if an SI prefix is allowed for this base unit
    var allowsPrefix: Bool {
        switch self {
        case .percent, .celsius:
            return false
        default:
            return true
        }
    }
}

// Create a composable Unit type that combines a SIPrefix with a BaseUnit
struct Unit: CustomStringConvertible, Codable {
    var prefix: SIPrefix
    var base: BaseUnit

    // Computed property to produce the full unit string (e.g., "MV" for megavolt)
    var description: String {
        return "\(prefix.rawValue)\(base.rawValue)"
    }
    
    // Validated initializer ensuring units that don't allow prefixes use .none
    init(prefix: SIPrefix, base: BaseUnit) {
        if !base.allowsPrefix && prefix != .none {
            fatalError("The base unit \(base.rawValue) cannot have an SI prefix other than .none.")
        }
        self.prefix = prefix
        self.base = base
    }
}
