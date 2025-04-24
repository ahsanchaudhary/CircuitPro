//
//  CursorTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI

struct CursorTool {
  var marquee = MarqueeTool()

  /// Called on tap (typically hit test)
  var selectionHandler: ((CGPoint, EventModifiers) -> Void)?

  /// Called when marquee ends
  var marqueeSelectionHandler: ((CGRect, EventModifiers) -> Void)?

  mutating func handleTap(at point: CGPoint, modifiers: EventModifiers) {
    selectionHandler?(point, modifiers)
  }

  mutating func beginMarquee(at point: CGPoint) {
    marquee.begin(at: point)
  }

  mutating func updateMarquee(to point: CGPoint) {
    marquee.update(to: point)
  }

  mutating func commitMarquee(modifiers: EventModifiers) {
    if let rect = marquee.boundingRect {
      marqueeSelectionHandler?(rect, modifiers)
    }
    marquee.reset()
  }

  func preview(using snap: (CGPoint) -> CGPoint) -> some View {
    marquee.preview(using: snap)
  }
}
