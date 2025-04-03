//
//  ProjectView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI

public struct ProjectView: View {
    let project: Project
    @State private var selectedView: ViewType = .schematic

    public var body: some View {
        VStack {
            // Main content area that switches based on the selected view
            switch selectedView {
            case .schematic:
                SchematicView()
            case .layout:
                LayoutView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("View", selection: $selectedView) {
                    Text("Schematics").tag(ViewType.schematic)
                    Text("Layout").tag(ViewType.layout)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .navigationTitle(project.name)
    }
}

enum ViewType {
    case schematic, layout
}


struct LayoutView: View {
    var body: some View {
        Text("Layout View")
    }
}


#Preview {
    ProjectView(project: Project(name: "Test Project"))
}
