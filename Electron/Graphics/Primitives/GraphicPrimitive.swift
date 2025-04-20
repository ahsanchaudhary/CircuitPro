//
//  GraphicPrimitive.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/20/25.
//
import SwiftUI

protocol GraphicPrimitive: Identifiable, Hashable, Codable {
    var id: UUID { get }
    var position: CGPoint { get set }
    var strokeWidth: CGFloat { get set }
    var color: SDColor { get set }
    var filled: Bool { get set }
}
