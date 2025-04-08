//
//  ComponentItem.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//
import SwiftUI


struct ComponentItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    
    
    var properties: [ComponentProperty] = []
    var symbol: SymbolItem
    var footprint: FootprintItem?
    var model: ModelItem?
}


struct ComponentProperty: Identifiable {
    var id: UUID = UUID()
    var name: String
    var value: PropertyValue
    var unit: Unit?
}

enum PropertyValue {
    case single(Double) // e.g. 100
    case range(min: Double, max: Double) // e.g. 3.0 to 5.0
    case withTolerance(value: Double, tolerance: Tolerance) // e.g. 100 ±10%
}

extension PropertyValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .single(let value):
            return "\(value)"
        case .range(let min, let max):
            return "\(min) to \(max)"
        case .withTolerance(let value, let tolerance):
            return "\(value) ±\(tolerance.min)%"
        }
    }
}

struct Tolerance {
    var min: Double // e.g. -10
    var max: Double // e.g. 10
    var unit: Unit // Usually "%"
}

