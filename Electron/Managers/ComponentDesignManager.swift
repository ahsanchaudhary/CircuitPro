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
    var selectedSymbolDesignTool: SymbolDesignToolbar = .cursor
    
    var activeGraphicsTool: AnyGraphicsTool? = nil
    
    func updateActiveTool() {
        switch selectedSymbolDesignTool {
        case .graphics(.line):
            activeGraphicsTool = .line(LineTool())
        case .graphics(.rectangle):
            activeGraphicsTool = .rectangle(RectangleTool())
        case .graphics(.circle):
            activeGraphicsTool = .circle(CircleTool())
        default:
            activeGraphicsTool = nil
        }
    }
}

