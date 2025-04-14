//
//  ProjectToolbar.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/14/25.
//


import SwiftUI
import SwiftData

struct ProjectToolbar: ToolbarContent {
    @Bindable var design: Design
    @Binding var selectedEditor: EditorType
    @Binding var isShowingInspector: Bool
    var openWindow: OpenWindowAction
    var modelContext: ModelContext

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            TextField("Design Name", text: $design.name)
                .font(.title3)
                .fontWeight(.semibold)
        }

        ToolbarItem(placement: .principal) {
            Picker("View", selection: $selectedEditor) {
                Text("Schematics").tag(EditorType.schematic)
                Text("Layout").tag(EditorType.layout)
            }
            .pickerStyle(.segmented)
        }

        ToolbarItem(placement: .primaryAction) {
            Button {
                openWindow(id: "SecondWindow")
            } label: {
                Label("Board Setup", systemImage: AppIcons.gear)
            }
        }

        ToolbarItem(placement: .primaryAction) {
            Button {
                isShowingInspector.toggle()
            } label: {
                Label("\(isShowingInspector ? "Hide" : "Show") Inspector", systemImage: AppIcons.infoCircle)
                    .labelStyle(.iconOnly)
            }
        }

        ToolbarItem(placement: .navigation) {
            Button {
                let newComponent = Component(name: "Resistor", symbol: Symbol(name: "Resistor"))
                modelContext.insert(newComponent)
            } label: {
                Image(systemName: AppIcons.plus)
            }
        }
    }
}
