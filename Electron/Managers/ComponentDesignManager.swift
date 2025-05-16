//
//  ComponentDesignManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/19/25.
//


import SwiftUI
import Observation

@Observable
final class ComponentDesignManager {
    
    var componentName: String = ""
    var componentAbbreviation: String = ""
    var selectedCategory: ComponentCategory?
    var selectedPackageType: PackageType?
    var componentProperties: [ComponentProperty] = [ComponentProperty(key: nil, value: .single(nil), unit: .init())]
    
    
    // MARK: - Symbol
    var symbolElements: [CanvasElement] = []
    var selectedSymbolTool: AnyCanvasTool = AnyCanvasTool(CursorTool())
    
    
    
    // MARK: - Footprint
    var footprintElements: [CanvasElement] = []

    var selectedFootprintTool: AnyCanvasTool = AnyCanvasTool(CursorTool())
    
}


