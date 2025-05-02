//
//  ClosedRange+Extensions.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/2/25.
//
import SwiftUI

extension ClosedRange where Bound: Comparable {
    func clamp(_ value: Bound) -> Bound {
        return Swift.min(Swift.max(lowerBound, value), upperBound)
    }
}
