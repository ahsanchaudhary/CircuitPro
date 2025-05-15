//
//  LabeledEnum.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/11/25.
//
import SwiftUI

/// A clean Displayable protocol for enums used in UI
protocol Displayable: CaseIterable, Identifiable, Codable, Hashable {
    var label: String { get }
}

extension Displayable {
    var id: Self { self }
}
