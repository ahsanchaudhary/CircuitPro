//
//  ProjectView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI


public struct ProjectView: View {
    
    @Environment(\.canvasManager) var canvasManager
    let project: Project
    @State private var selectedEditor: EditorType = .layout
    @State private var selectedLayoutInspector: LayoutInspectorType = .layers

    @State private var isShowingInspector: Bool = false
    
    public var body: some View {
        VStack {
            // Main content area that switches based on the selected view
            switch selectedEditor {
            case .schematic:
                SchematicView()
                    .overlay(alignment: .topTrailing) {
                        SchematicToolbarView()
                            .padding(10)
                    }
            case .layout:
                LayoutView()
                    .overlay(alignment: .topTrailing) {
                        LayoutToolbarView()
                            .padding(10)
                    }
            }
        }
        .onAppear {
            for layer in project.layout?.layers ?? [] {
                print(layer.color)
            }
          
        }
        .inspector(isPresented: $isShowingInspector) {
            VStack {
                switch selectedEditor {
                case .schematic:
                    NetListView(nets: project.schematic?.nets ?? [])
                case .layout:
                    VStack {
                        HStack {
                            Button {
                                selectedLayoutInspector = .layers
                            } label: {
                                Image (systemName: "square.3.layers.3d")
                                    .foregroundStyle(selectedLayoutInspector == .layers ? .primary : .secondary)
                            }

                   
                             
                         
                            Divider()
                                .frame(height: 20)
                            Button {
                                selectedLayoutInspector = .nets
                            } label: {
                                Image(systemName: "point.3.connected.trianglepath.dotted")
                                    .foregroundStyle(selectedLayoutInspector == .nets ? .primary : .secondary)
                            }
                          
                           
                        }
                        .font(.callout)
                        .buttonStyle(.accessoryBar)
                        switch selectedLayoutInspector {
                        case .layers:
                            LayerListView(layers: project.layout?.layers ?? [])
                        case .nets:
                         
                            NetListView(nets: project.schematic?.nets ?? [])
                        }
                        
                    }
                   
                }
            
                Spacer()
                 
            }
            .padding(.top, 5)
            .inspectorColumnWidth(min: 200, ideal: 200, max: 250)
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("View", selection: $selectedEditor) {
                    Text("Schematics").tag(EditorType.schematic)
                    Text("Layout").tag(EditorType.layout)
                }
                .pickerStyle(.segmented)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation {
                        canvasManager.showComponentDrawer.toggle()
                    }
                } label: {
                    Label("Board Setup", systemImage: "gearshape")
                }

            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingInspector.toggle()
                } label: {
                    Label("\(isShowingInspector ? "Hide" : "Show") Inspector", systemImage: "info.circle")
                        .labelStyle(.iconOnly)
             
                }
            }
         

            
        }
        .navigationTitle(project.name)
    }
}





#Preview {
    ProjectView(project: Project(name: "Test Project"))
}
