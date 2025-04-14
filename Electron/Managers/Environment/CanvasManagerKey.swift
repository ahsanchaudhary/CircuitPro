//
//  CanvasManagerKey.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//
import SwiftUI

private struct CanvasManagerKey: EnvironmentKey {
    static let defaultValue: CanvasManager = CanvasManager()
}

extension EnvironmentValues {
    var canvasManager: CanvasManager {
        get { self[CanvasManagerKey.self] }
        set { self[CanvasManagerKey.self] = newValue }
    }
}
