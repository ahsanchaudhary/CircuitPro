//
//  requiring.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//


import SwiftUI


protocol ToolbarTool: Hashable {
    static var defaultTool: Self { get }
}

// Generic toolbar view constrained to ToolbarTool.
struct ToolbarView<Tool: ToolbarTool>: View {
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
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
        .buttonStyle(.borderless)
    }
    
    var toolbarContent: some View {
        VStack(spacing: 0) {
            ForEach(tools, id: \.self) { tool in
                Button {
                    selectedTool = tool
                    onToolSelected(tool)
                } label: {
                    Image(systemName: imageName(tool))
                        .font(.headline)
                        .foregroundStyle(selectedTool == tool ? .blue : .secondary)
                }
                .padding(10)
                .contentShape(RoundedRectangle(cornerRadius: 5))
                .background(hoveredTool == tool ? Color.gray.opacity(0.1) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .onHover { hoverState in
                    hoveredTool = hoverState ? tool : nil
                }
                
                // Optionally insert a divider after this tool.
                if let dividerAfter = dividerAfter, dividerAfter(tool) {
                    Divider().frame(width: 15)
                }
            }
        }
    }
}
