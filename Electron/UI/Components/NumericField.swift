import SwiftUI

struct IntegerField: View {
    let title: String
    @Binding var value: Int
    var placeholder: String = ""
    var range: ClosedRange<Int>? = nil
    var allowNegative: Bool = false

    @State private var text: String = ""

    var body: some View {
        TextField(title, text: $text)
            .onAppear {
                // initialize the text from the bound value
                text = String(value)
            }
            .onChange(of: text) { _, newValue in
                // 1) strip out anything that isn't a digit or '-'
                let filtered = filterInput(newValue)
                guard filtered == newValue else {
                    text = filtered
                    return
                }

                // 2) try to parse an Int; if that succeeds, clamp & sync
                if let intVal = Int(filtered) {
                    let clamped = clamp(intVal, to: range)
                    value = clamped
                    text = String(clamped)
                }
            }
    }

    private func filterInput(_ input: String) -> String {
        // keep only numbers and minus signs
        var result = input.filter { $0.isNumber || $0 == "-" }

        // enforce at most one leading minus
        if allowNegative {
            // remove all minus signs, then re-prefix if there was at least one
            let hasMinus = result.contains("-")
            result.removeAll { $0 == "-" }
            if hasMinus {
                result = "-" + result
            }
        } else {
            // drop any minus signs
            result.removeAll { $0 == "-" }
        }

        return result
    }

    private func clamp(_ x: Int, to bounds: ClosedRange<Int>?) -> Int {
        guard let b = bounds else { return x }
        return Swift.min(Swift.max(x, b.lowerBound), b.upperBound)
    }
}
