import SwiftUI

struct UnitColumn: View {
    @Binding var property: ComponentProperty

    var body: some View {
        HStack {
            Menu {
                ForEach(SIPrefix.allCases, id: \.rawValue) { prefix in
                    Button {
                        property.unit.prefix = prefix
                    } label: {
                     
                        Text(prefix.name)
                              
                    }
                }
            } label: {
                Text(property.unit.prefix.symbol)
            }
            .disabled(!(property.unit.base?.allowsPrefix ?? false)) // Disable if base doesn't allow prefix

            // Base Unit Menu
            Menu {
                ForEach(BaseUnit.allCases, id: \.rawValue) { base in
                    Button {
                        property.unit.base = base
                        if !base.allowsPrefix {
                            property.unit.prefix = .none // Reset prefix if not allowed
                        }
                    } label: {
                        Text(base.name)
                    }
                }
            } label: {
                Text(property.unit.base?.symbol ?? "–")
                    .foregroundStyle(property.unit.base == nil ? .secondary : .primary)
            }
        }
    }
}
