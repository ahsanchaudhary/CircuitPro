//
//  ComponentItem.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//


import SwiftData
import Foundation

@Model
class Component {

    var name: String
    
    var symbol: Symbol
    var footprint: Footprint?
    var model: Model?
    
    var properties: [ComponentProperty]

    init(name: String, symbol: Symbol, footprint: Footprint? = nil, model: Model? = nil, properties: [ComponentProperty] = []) {
        self.name = name
        self.symbol = symbol
        self.footprint = footprint
        self.model = model
        self.properties = properties
    }
 
}


struct ComponentProperty: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var value: PropertyValue
    var unit: Unit
}

enum PropertyValue: Codable {
    case single(Double)
    case range(min: Double, max: Double)

    private enum CodingKeys: String, CodingKey {
        case type, value, min, max
    }

    private enum ValueType: String, Codable {
        case single, range
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ValueType.self, forKey: .type)

        switch type {
        case .single:
            let value = try container.decode(Double.self, forKey: .value)
            self = .single(value)
        case .range:
            let min = try container.decode(Double.self, forKey: .min)
            let max = try container.decode(Double.self, forKey: .max)
            self = .range(min: min, max: max)

        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .single(let value):
            try container.encode(ValueType.single, forKey: .type)
            try container.encode(value, forKey: .value)
        case .range(let min, let max):
            try container.encode(ValueType.range, forKey: .type)
            try container.encode(min, forKey: .min)
            try container.encode(max, forKey: .max)


    
        }
    }
}


extension PropertyValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .single(let value):
            return "\(value)"
        case .range(let min, let max):
            return "\(min) to \(max)"

        }
    }
}
