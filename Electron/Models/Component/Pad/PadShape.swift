//
//  PadShape.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/5/25.
//
import SwiftUI

enum PadShape: Codable {
    case rect(width: Double, height: Double)
    case circle(radius: Double)

    private enum CodingKeys: String, CodingKey {
        case type, width, height, radius
    }
    private enum ShapeType: String, Codable {
        case rect, circle
    }

    // Decoding
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(ShapeType.self, forKey: .type)
        switch type {
        case .rect:
            let w = try c.decode(Double.self, forKey: .width)
            let h = try c.decode(Double.self, forKey: .height)
            self = .rect(width: w, height: h)
        case .circle:
            let r = try c.decode(Double.self, forKey: .radius)
            self = .circle(radius: r)
        }
    }

    // Encoding
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .rect(let width, let height):
            try c.encode(ShapeType.rect, forKey: .type)
            try c.encode(width,  forKey: .width)
            try c.encode(height, forKey: .height)
        case .circle(let radius):
            try c.encode(ShapeType.circle, forKey: .type)
            try c.encode(radius, forKey: .radius)
        }
    }
}
