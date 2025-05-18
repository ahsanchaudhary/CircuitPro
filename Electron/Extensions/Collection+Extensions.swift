//
//  Collection+Extensions.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/14/25.
//

import SwiftUI

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
