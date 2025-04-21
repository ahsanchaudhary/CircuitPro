//
//  requiring.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//


import SwiftUI


protocol ToolbarContext: Hashable & CaseIterable {
  /// The `cursor` case for this tool context
  static var cursorCase: Self { get }
}

extension ToolbarContext {
  /// The default tool (always cursor)
  static var defaultTool: Self { cursorCase }

  /// A list of all tools with cursor placed at the top
  static var allWithCursorFirst: [Self] {
    [cursorCase] + allCases.filter { $0 != cursorCase }
  }
}

enum GraphicsToolbar: String, CaseIterable, Hashable {
  case line = "line.diagonal"
  case rectangle = "rectangle"
  case circle = "circle"

  var symbolName: String { rawValue }
  var label: String { rawValue.capitalized }
}

// Generic toolbar view constrained to ToolbarTool.
struct ToolbarView<Tool: ToolbarContext>: View {
    let tools: [Tool]
    let dividerAfter: ((Tool) -> Bool)?
    let imageName: (Tool) -> String
    let onToolSelected: (Tool) -> Void

    // Use the default cursor as the initial value.
    @State private var selectedTool: Tool = Tool.defaultTool
    @State private var hoveredTool: Tool?

    var body: some View {
        ViewThatFits {
            toolbarContent
            ScrollView {
                
                toolbarContent
                
            }
            .scrollIndicators(.never)
        }
       
        
        .background(.thinMaterial)
        .clipAndStroke(with: .rect(cornerRadius: 10), strokeColor: .gray.opacity(0.3), lineWidth: 1)
        .buttonStyle(.borderless)
    }
    
    var toolbarContent: some View {
        VStack(spacing: 5) {
            ForEach(tools, id: \.self) { tool in
               
                toolbarButton(tool)
                // Optionally insert a divider after this tool.
                if let dividerAfter = dividerAfter, dividerAfter(tool) {
                    Divider().frame(width: 15)
                }
            }
            
        }
        .padding(5)
    }
    
    func toolbarButton(_ tool: Tool) -> some View {
        Button {
            selectedTool = tool
            onToolSelected(tool)
        } label: {
            Image(systemName: imageName(tool))
                .font(.title2)
                .frame(width: 15, height: 15)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(selectedTool == tool ? .blue : .secondary)
        }
        .padding(10)
        .contentShape(RoundedRectangle(cornerRadius: 5))
        .background(hoveredTool == tool ? Color.gray.opacity(0.1) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .onHover { hoverState in
            hoveredTool = hoverState ? tool : nil
        }
    }
}
