//
//  Symbol.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//

import SwiftUI
import SwiftData
import Foundation

@Model
class Symbol {

    @Attribute(.unique)
    var uuid: UUID
    @Attribute(.unique)
    var name: String
    
    var component: Component?
    
    var primitives: [GraphicPrimitiveType]
    
    var pins: [Pin]

    init(uuid: UUID = UUID(), name: String, component: Component? = nil, primitives: [GraphicPrimitiveType] = [], pins: [Pin] = []) {
self.uuid = uuid
        self.name = name
        self.component = component
        self.primitives = primitives
        self.pins = pins
    }
}


struct Pin: Identifiable, Codable {
    var id: UUID = UUID()
    var position: SDPoint
    var type: PinType

}

enum PinType: String, CaseIterable, Identifiable, Codable {
    case input
    case output
    case bidirectional
    case power
    case ground
    case passive
    case analog
    case clock
    case notConnected
    case unknown

    var id: String { rawValue }

    var label: String {
        switch self {
        case .input: return "Input"
        case .output: return "Output"
        case .bidirectional: return "Bidirectional"
        case .power: return "Power"
        case .ground: return "Ground"
        case .passive: return "Passive"
        case .analog: return "Analog"
        case .clock: return "Clock"
        case .notConnected: return "Not Connected"
        case .unknown: return "Unknown"
        }
    }
}
