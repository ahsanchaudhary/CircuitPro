//
//  ContainerReloadKey.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/13/25.
//


import SwiftUI

/// A custom environment key to allow views to trigger a container reload.
struct ContainerReloadKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var reloadContainer: () -> Void {
        get { self[ContainerReloadKey.self] }
        set { self[ContainerReloadKey.self] = newValue }
    }
}
