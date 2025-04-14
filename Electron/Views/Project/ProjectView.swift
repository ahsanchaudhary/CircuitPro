//
//  ProjectView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI
import SwiftData

enum DesignChild: Identifiable {
    case schematic(Schematic)
    case layout(Layout)

    var id: PersistentIdentifier {
        switch self {
        case .schematic(let s): return s.id
        case .layout(let l): return l.id
        }
    }

    var title: String {
        switch self {
        case .schematic(let s): return "📘 \(s.title)"
        case .layout(let l): return "📐 \(l.title)"
        }
    }
}


extension Design {
    var children: [DesignChild] {
        [.schematic(schematic), .layout(layout)]
    }
}


public struct ProjectView: View {
    
    @Environment(\.projectManager) private var projectManager
    @Environment(\.canvasManager) private var canvasManager
    @Environment(\.openWindow) private var openWindow
    @Environment(\.modelContext) private var modelContext
    
    let project: Project
    
    @State private var selectedEditor: EditorType = .schematic
    @State private var selectedLayoutInspector: LayoutInspectorType = .layers

    @State private var isShowingInspector: Bool = false
    
    public var body: some View {
        NavigationSplitView {
            if !project.designs.isEmpty {
                List {
                    Section("Designs") {
                        ForEach(project.designs) { design in
                            DisclosureGroup(design.name) {
                                ForEach(design.children) { child in
                                    Text(child.title)
                                }
                            }
                        }
                    }
                    
                }
            } else {
                Button {
                    
                } label: {
                    Text("Add a new Design")
                }

            }
        } detail: {
            projectDetail
        }

      
    }
    var projectDetail: some View {
        VStack {
            if projectManager.selectedDesign != nil {
                switch selectedEditor {
                case .schematic:
                    SchematicView()
                      
               
                case .layout:
    //                    LayoutView(layout: project.layout)
                       Text("Layoutview")
                }
            } else {
                if project.designs.isNotEmpty {
                    ForEach(project.designs) { design in
                        Text("Design \(design.name)")
                            .onTapGesture {
                                projectManager.selectedDesign = design
                            }
                    }
                } else {
                    Button {
                        
                    } label: {
                        Text("Add a new Design")
                    }
                }
               
            }
 
        }
        .inspector(isPresented: $isShowingInspector) {
            inspectorContent
        }
        .toolbar {
            if let selectedDesign = projectManager.selectedDesign {
                ToolbarItem(placement: .navigation) {
                    @Bindable var bindableDesign: Design = selectedDesign
                    TextField("Design Name", text: $bindableDesign.name)
                    
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
                    let newComponent = Component(name: "Capacitor", symbol: Symbol(name: "Capacitor"))
                    modelContext.insert(newComponent)
                    
                } label: {
                    Image(systemName: AppIcons.plus)
                }

            }
         

            
        }
        .navigationTitle("")
    }
    
    var inspectorContent: some View {
        VStack {
            switch selectedEditor {
            case .schematic:
//                        NetListView(nets: project.schematic?.nets ?? [])
                Text("Netlistview")
            case .layout:
                VStack {
                    HStack {
                        Button {
                            selectedLayoutInspector = .layers
                        } label: {
                            Image (systemName: AppIcons.layoutLayers)
                                .foregroundStyle(selectedLayoutInspector == .layers ? .primary : .secondary)
                        }

               
                         
                     
                        Divider()
                            .frame(height: 20)
                        Button {
                            selectedLayoutInspector = .nets
                        } label: {
                            Image(systemName: AppIcons.layoutNets)
                                .foregroundStyle(selectedLayoutInspector == .nets ? .primary : .secondary)
                        }
                      
                       
                    }
                    .font(.callout)
                    .buttonStyle(.accessoryBar)
                    switch selectedLayoutInspector {
                    case .layers:
//                                LayerListView(layers: project.layout?.layers ?? [])
                        Text("Layer list view")
                    case .nets:
                     
//                                NetListView(nets: project.schematic?.nets ?? [])
                        Text("NetlistView yo")
                    }
                    
                }
               
            }
        
            Spacer()
             
        }
        .padding(.top, 5)
        .inspectorColumnWidth(min: 200, ideal: 200, max: 250)
        
    }
    
}





#Preview {
    
    ProjectView(project: Project(name: "Test Project", designs: []))
 
}

