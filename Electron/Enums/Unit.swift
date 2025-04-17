import SwiftUI

// Define SI Prefixes
enum SIPrefix: String, CaseIterable, Codable {
    case none  = "-"
    case pico  = "p"
    case nano  = "n"
    case micro = "μ"
    case milli = "m"
    case kilo  = "k"
    case mega  = "M"
    case giga  = "G"

    /// The symbol you’ve been using
    var symbol: String { rawValue }

    /// The full name for display purposes
    var name: String {
        switch self {
        case .none:  return "-"
        case .pico:  return "pico"
        case .nano:  return "nano"
        case .micro: return "micro"
        case .milli: return "milli"
        case .kilo:  return "kilo"
        case .mega:  return "mega"
        case .giga:  return "giga"
        }
    }
}

// Define Base Units for electronic components
enum BaseUnit: String, CaseIterable, Codable {
    case ohm     = "Ω"
    case farad   = "F"
    case henry   = "H"
    case volt    = "V"
    case ampere  = "A"
    case watt    = "W"
    case hertz   = "Hz"
    case celsius = "°C"
    case percent = "%"

    /// The symbol you’ve been using
    var symbol: String { rawValue }

    /// The full name for display purposes
    var name: String {
        switch self {
        case .ohm:     return "Ohm"
        case .farad:   return "Farad"
        case .henry:   return "Henry"
        case .volt:    return "Volt"
        case .ampere:  return "Ampere"
        case .watt:    return "Watt"
        case .hertz:   return "Hertz"
        case .celsius: return "Celsius"
        case .percent: return "Percent"
        }
    }

    /// Computed property to indicate if an SI prefix is allowed
    var allowsPrefix: Bool {
        switch self {
        case .percent, .celsius:
            return false
        default:
            return true
        }
    }
}

// Composable Unit type combining an SIPrefix with a BaseUnit
struct Unit: CustomStringConvertible, Codable {
    var prefix: SIPrefix
    var base:   BaseUnit

    /// Symbolic form, e.g. "kΩ"
    var symbol: String {
        "\(prefix.symbol)\(base.symbol)"
    }

    /// Human‐readable name, e.g. "kilo Ohm"
    var name: String {
        // omit the prefix name for `.none`
        let p = prefix == .none ? "" : prefix.name
        return [p, base.name]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    /// Conform to CustomStringConvertible to keep your existing logic
    var description: String { symbol }

    /// Validated initializer ensuring forbidden prefixes aren’t used
    init(prefix: SIPrefix, base: BaseUnit) {
        if !base.allowsPrefix && prefix != .none {
            fatalError("The base unit \(base.symbol) cannot have an SI prefix other than .none.")
        }
        self.prefix = prefix
        self.base   = base
    }
}
