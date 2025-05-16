//
//  GraphicPrimitive.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/14/25.
//
import AppKit

protocol GraphicPrimitive: Identifiable, Hashable, Codable {
    var uuid: UUID       { get }
    var position: CGPoint { get set }
    var rotation: CGFloat { get set }
    var strokeWidth: CGFloat { get set }
    var color: SDColor    { get set }
    var filled: Bool      { get set }

    func handles() -> [Handle]

    // NEW unified signature   (the last parameter is optional)
    mutating func updateHandle(
        _        kind: Handle.Kind,
        to       position: CGPoint,
        opposite frozenOpposite: CGPoint?)
    
    func makePath(offset: CGPoint) -> CGPath
    
}

extension GraphicPrimitive {
    var id: UUID { uuid }
}

extension GraphicPrimitive {
    mutating func updateHandle(
        _ kind: Handle.Kind,
        to position: CGPoint)
    {
        updateHandle(kind, to: position, opposite: nil)
    }

}

