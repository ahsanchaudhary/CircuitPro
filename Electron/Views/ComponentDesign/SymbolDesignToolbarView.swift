//
//  SymbolDesignToolbarView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/19/25.
//
import SwiftUI

enum SymbolDesignToolbar: Hashable, ToolbarContext {
  case cursor
  case graphics(GraphicsToolbar)

  static var cursorCase: SymbolDesignToolbar { .cursor }

    static var allCases: [SymbolDesignToolbar] {
      [.cursor] + GraphicsToolbar.allCases.map { .graphics($0) }
    }


  var symbolName: String {
    switch self {
    case .cursor: return "cursorarrow"
    case .graphics(let tool): return tool.symbolName
    }
  }

  var label: String {
    switch self {
    case .cursor: return "Cursor"
    case .graphics(let tool): return tool.label
    }
  }
}


protocol GraphicsTool {
  associatedtype Preview: View

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType?
  
  @ViewBuilder
  func preview(mousePosition: CGPoint) -> Preview
}

enum AnyGraphicsTool {
  case line(LineTool)
  case rectangle(RectangleTool)
  case circle(CircleTool)

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    switch self {
    case .line(var tool): let result = tool.handleTap(at: location); self = .line(tool); return result
    case .rectangle(var tool): let result = tool.handleTap(at: location); self = .rectangle(tool); return result
    case .circle(var tool): let result = tool.handleTap(at: location); self = .circle(tool); return result
    }
  }

  @ViewBuilder
  func preview(mousePosition: CGPoint) -> some View {
    switch self {
    case .line(let tool): tool.preview(mousePosition: mousePosition)
    case .rectangle(let tool): tool.preview(mousePosition: mousePosition)
    case .circle(let tool): tool.preview(mousePosition: mousePosition)
    }
  }
}

struct LineTool: GraphicsTool {
  var start: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let s = start {
      let line = GraphicPrimitiveType.line(
        .init(strokeWidth: 1, color: .init(color: .orange), start: s, end: location)
      )
      start = nil
      return line
    } else {
      start = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      Group {
          if let s = start {
              Path { $0.move(to: s); $0.addLine(to: mousePosition) }
                  .stroke(.orange, style: .init(lineWidth: 1, dash: [4]))
                  .allowsHitTesting(false)
          }
      }
  }
}

import SwiftUI

struct RectangleTool: GraphicsTool {
  var start: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let s = start {
      let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: location, size: .zero))
      let center = CGPoint(x: rect.midX, y: rect.midY)
      let prim = GraphicPrimitiveType.rectangle(
        .init(
          position: center,
          strokeWidth: 1,
          color: .init(color: .green),
          filled: false,
          size: rect.size,
          cornerRadius: 0
        )
      )
      start = nil
      return prim
    } else {
      start = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      Group {
          if let s = start {
              let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: mousePosition, size: .zero))
              Path { $0.addRect(rect) }
                  .stroke(.green, style: .init(lineWidth: 1, dash: [4]))
                  .allowsHitTesting(false)
          }
    }
  }
}

import SwiftUI
import SwiftUI

struct CircleTool: GraphicsTool {
  var center: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let c = center {
      let r = hypot(location.x - c.x, location.y - c.y)
      let prim = GraphicPrimitiveType.circle(
        .init(
          position: c,
          strokeWidth: 1,
          color: .init(color: .blue),
          filled: false,
          radius: r
        )
      )
      center = nil
      return prim
    } else {
      center = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
    Group {
      if let c = center {
        let radius = hypot(mousePosition.x - c.x, mousePosition.y - c.y)

        ZStack {
          // Circle outline
          Circle()
            .stroke(.blue, style: .init(lineWidth: 1, dash: [4]))
            .frame(width: radius * 2, height: radius * 2)
            .position(c)

          // Radius line
          Path { path in
            path.move(to: c)
            path.addLine(to: mousePosition)
          }
          .stroke(.gray.opacity(0.5))

          // Radius text
          Text(String(format: "%.1f", radius))
                .font(.caption2)
            .foregroundColor(.blue)
            .directionalPadding(vertical: 2.5, horizontal: 5)
            .background(.thinMaterial)
            .clipAndStroke(with: .capsule)
            .position(x: (c.x + mousePosition.x) / 2,
                      y: (c.y + mousePosition.y) / 2 - 10)
        }
        .allowsHitTesting(false)
      }
    }
  }
}




struct SymbolDesignToolbarView: View {
    
    @Environment(\.componentDesignManager) private var componentDesignManager
   
    
    var body: some View {
        ToolbarView<SymbolDesignToolbar>(
            tools: SymbolDesignToolbar.allCases,
            // Insert a divider after the cursor and zone tools.
            dividerAfter: { tool in
                tool == .cursor
            },
            imageName: { $0.symbolName },
            onToolSelected: { tool in
                // Handle layout tool selection.
                print("Layout tool selected:", tool)
            
                componentDesignManager.selectedSymbolDesignTool = tool
                componentDesignManager.updateActiveTool()
            }
        )
    }
}
