//
//  ComponentView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/7/25.
//

import SwiftUI
import RealityKit

struct ComponentView: View {
    
    let component: Component
    
    @State private var showSheet: Bool = false
    
    enum ComponentViewType: CaseIterable {
        case symbol
        case footprint
        case model3D

        var label: String {
            switch self {
            case .symbol: return "Symbol"
            case .footprint: return "Footprint"
            case .model3D: return "3D Model"
            }
        }

        var icon: String {
            switch self {
            case .symbol: return AppIcons.symbol
            case .footprint: return AppIcons.footprint
            case .model3D: return AppIcons.model3D
            }
        }

        func isAvailable(in component: Component) -> Bool {
            switch self {
            case .symbol:
                return true // always available
            case .footprint:
                return component.footprint != nil
            case .model3D:
                return component.model != nil
            }
        }
    }


    
    @State private var selectedView: ComponentViewType = .symbol
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    HStack {
                        Text(component.name)
                            .lineLimit(1)
                        Spacer()
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: AppIcons.arrowUpRight)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(.accessoryBar)
                        
                        
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    Spacer()
                    switch selectedView {
                    case .symbol:
                        Text("Symbol View")
                    case .footprint:
                        if component.footprint == nil {
                            Image(AppIcons.photoTriangleBadgeExclamationMark)
                                .font(.largeTitle)
                                .imageScale(.large)
                                .foregroundStyle(.quaternary)
                            
                        } else {
                            Text("Footprint View")
                        }
                    case .model3D:
                                            if component.model == nil {
                                                Image(AppIcons.photoTriangleBadgeExclamationMark)
                                            } else {
                                                realityView(component.model?.name ?? "HC-SR04")
                                            }
                        Text("Model View")
                        
                    }
                    Spacer()
                    
                    
                }
                
                            Spacer()
                            HStack {
                                ForEach(ComponentViewType.allCases, id: \.self) { type in
                                    Button {
                                        selectedView = type
                                    } label: {
                                        Label(type.label, systemImage: type.icon)
                                            .foregroundStyle(selectedView == type ? .blue : .primary)
                                    }
                                    .disabled(!type.isAvailable(in: component))
                
                                    if type != ComponentViewType.allCases.last {
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .labelStyle(.iconOnly)
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                
                
            }
            .padding(5)
            .frame(width: 150, height: 150)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
            }
            .draggable(TransferableComponent(componentUUID: component.uuid, symbolUUID: component.symbol.uuid, properties: component.properties))
            .sheet(isPresented: $showSheet) {
                ComponentPropertiesView(component: component)
                    .presentationSizing(.fitted)
                    .frame(
                        minWidth: 600, maxWidth: 800,
                        minHeight: 400, maxHeight: 600)
            }
        }
    
    }
    
    func realityView(_ name: String) -> some View {
        RealityView { content in
            if let model = try? await ModelEntity(named: name) {
                content.add(model)
                
                model.scale = .init(x: 30, y: 30, z: 30)
            }
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    ComponentView(component: Component(name: "Pololu Distance Sensor", symbol: Symbol(name: "Polulu Distance Sensor")))
}
