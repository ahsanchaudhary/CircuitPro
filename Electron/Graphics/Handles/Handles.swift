//
//  LineHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI


extension GraphicPrimitiveType {
  @ViewBuilder
  static func handles(for binding: Binding<GraphicPrimitiveType>) -> some View {
    switch binding.wrappedValue {
    case .line(let line):
      LineHandles(line: line) { new in
        binding.wrappedValue = .line(new)
      }

    case .rectangle(let rect):
      RectangleHandles(rect: rect) { new in
        binding.wrappedValue = .rectangle(new)
      }

    case .circle(let circle):
      CircleHandles(circle: circle) { new in
        binding.wrappedValue = .circle(new)
      }

    case .arc:
      EmptyView()
    }
  }
}
