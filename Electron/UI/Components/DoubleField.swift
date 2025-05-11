//
//  DoubleField.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/9/25.
//


import SwiftUI

struct DoubleField: View {
    let title: String
    @Binding var value: Double
    var placeholder: String = ""
    var range: ClosedRange<Double>? = nil
    var allowNegative: Bool = true
    var maxDecimalPlaces: Int = 3

    @State private var text: String = ""

    var body: some View {
        TextField(title, text: $text)
            .onAppear {
                text = String(value)
            }
            .onChange(of: text) { _, newValue in
                let filtered = filterInput(newValue)
                guard filtered == newValue else {
                    text = filtered
                    return
                }

                if let doubleVal = Double(filtered) {
                    let clamped = clamp(doubleVal, to: range)
                    value = clamped
                    text = formatted(clamped)
                }
            }
    }

    private func filterInput(_ input: String) -> String {
        var result = input.filter { $0.isNumber || $0 == "." || $0 == "-" }

        // Only allow one decimal point
        let decimalParts = result.split(separator: ".")
        if decimalParts.count > 2 {
            result = decimalParts.prefix(2).joined(separator: ".")
        }

        // Enforce max decimal digits
        if let dotIndex = result.firstIndex(of: ".") {
            let afterDecimal = result[dotIndex...].dropFirst()
            if afterDecimal.count > maxDecimalPlaces {
                result = String(result.prefix(upTo: dotIndex)) + "." + afterDecimal.prefix(maxDecimalPlaces)
            }
        }

        // Handle minus sign
        if allowNegative {
            let hasMinus = result.contains("-")
            result.removeAll { $0 == "-" }
            if hasMinus {
                result = "-" + result
            }
        } else {
            result.removeAll { $0 == "-" }
        }

        return result
    }

    private func clamp(_ x: Double, to bounds: ClosedRange<Double>?) -> Double {
        guard let b = bounds else { return x }
        return min(max(x, b.lowerBound), b.upperBound)
    }

    private func formatted(_ value: Double) -> String {
        String(format: "%.\(maxDecimalPlaces)f", value)
    }
}
