//
//  MarqueeTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI

struct MarqueeTool {
  var start: CGPoint?
  var end: CGPoint?

  mutating func begin(at point: CGPoint) {
    start = point
    end = point
  }

  mutating func update(to point: CGPoint) {
    end = point
  }

  mutating func reset() {
    start = nil
    end = nil
  }

  var boundingRect: CGRect? {
    guard let start, let end else { return nil }
    return CGRect(
      x: min(start.x, end.x),
      y: min(start.y, end.y),
      width: abs(end.x - start.x),
      height: abs(end.y - start.y)
    )
  }

  func preview(using snap: (CGPoint) -> CGPoint) -> some View {
    Group {
      if let start, let end {
        let snappedStart = snap(start)
        let snappedEnd = snap(end)
        let rect = CGRect(
          x: min(snappedStart.x, snappedEnd.x),
          y: min(snappedStart.y, snappedEnd.y),
          width: abs(snappedEnd.x - snappedStart.x),
          height: abs(snappedEnd.y - snappedStart.y)
        )

        Path { $0.addRect(rect) }
          .stroke(.blue, lineWidth: 1)
          .background(
            Path { $0.addRect(rect) }
              .fill(.blue.opacity(0.1))
          )
          .allowsHitTesting(false)
      }
    }
  }
}
