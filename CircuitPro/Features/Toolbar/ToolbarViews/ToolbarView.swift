//
//  requiring.swift
//  Circuit Pro
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI

/// A generic toolbar driven by any CanvasTool.
struct ToolbarView<Tool: CanvasTool>: View {
    let tools: [Tool]
    let dividerBefore: ((Tool) -> Bool)?
    let dividerAfter: ((Tool) -> Bool)?
    let imageName: (Tool) -> String
    let onToolSelected: (Tool) -> Void

    @State private var selectedTool: Tool
    @State private var hoveredTool: Tool?

    init(
        tools: [Tool],
        dividerBefore: ((Tool) -> Bool)? = nil,
        dividerAfter: ((Tool) -> Bool)? = nil,
        imageName: @escaping (Tool) -> String,
        onToolSelected: @escaping (Tool) -> Void
    ) {
        self.tools = tools
        self.dividerBefore = dividerBefore
        self.dividerAfter = dividerAfter
        self.imageName = imageName
        self.onToolSelected = onToolSelected
        _selectedTool = State(initialValue: tools.first!)
    }

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

    private var toolbarContent: some View {
        VStack(spacing: 5) {
            ForEach(tools, id: \.self) { tool in
                if let dividerBefore = dividerBefore, dividerBefore(tool) {
                    Divider().frame(width: 15)
                }
                toolbarButton(tool)
                if let dividerAfter = dividerAfter, dividerAfter(tool) {
                    Divider().frame(width: 15)
                }
            }
        }
        .padding(5)
    }

    private func toolbarButton(_ tool: Tool) -> some View {
        Button {
            selectedTool = tool
            onToolSelected(tool)
        } label: {
            Image(systemName: imageName(tool))
                .font(.title2)
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(selectedTool == tool ? .blue : .secondary)
        }
        .padding(10)
        .contentShape(RoundedRectangle(cornerRadius: 5))
        .background(hoveredTool == tool ? Color.gray.opacity(0.1) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .onHover { hover in hoveredTool = hover ? tool : nil }
        .help("\(tool.label) Tool\nShortcut:")
    }
}
