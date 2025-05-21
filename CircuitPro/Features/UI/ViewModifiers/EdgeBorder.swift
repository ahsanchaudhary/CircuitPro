//
//  EdgeBorder.swift
//  Circuit Pro
//
//  Created by Giorgi Tchelidze on 4/21/25.
//


import SwiftUI

struct EdgeBorder: ViewModifier {
    var edge: Edge
    var color: Color
    var thickness: CGFloat

    func body(content: Content) -> some View {
        content.overlay(alignment: alignment(for: edge)) {
            Rectangle()
                .frame(width: edge.isVertical ? thickness : nil,
                       height: edge.isHorizontal ? thickness : nil)
                .foregroundColor(color)
        }
    }

    private func alignment(for edge: Edge) -> Alignment {
        switch edge {
        case .top: return .top
        case .bottom: return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
}

private extension Edge {
    var isVertical: Bool { self == .leading || self == .trailing }
    var isHorizontal: Bool { self == .top || self == .bottom }
}

extension View {
    func border(edge: Edge, color: Color, thickness: CGFloat = 1) -> some View {
        self.modifier(EdgeBorder(edge: edge, color: color, thickness: thickness))
    }
}
