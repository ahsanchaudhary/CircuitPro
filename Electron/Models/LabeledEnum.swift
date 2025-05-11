//
//  LabeledEnum.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/11/25.
//
import SwiftUI

protocol Displayable: RawRepresentable, CaseIterable, Identifiable, Codable where RawValue == String {
    var label: String { get }
}

extension Displayable {
    var id: String { rawValue }
}
