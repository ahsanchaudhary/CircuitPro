//
//  PadEditorView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/9/25.
//

import SwiftUI

struct PadEditorView: View {
    @Environment(\.componentDesignManager) private var componentDesignManager

    let pads: [Pad]
    @Binding var selectedPads: [Pad]

    var body: some View {
        StageSidebarView {
            Text("Pads")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(pads) { pad in
                        let isSelected = selectedPads.contains(where: { $0.id == pad.id })
                        Text("Pad \(pad.number)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .directionalPadding(vertical: 5, horizontal: 7.5)
                            .background(isSelected ? .gray.opacity(0.3) : .gray.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 5))
                            .onTapGesture {
                                togglePadSelection(pad: pad)
                            }
                    }
                }
            }
            .scrollClipDisabled()
        } content: {
            if selectedPads.isNotEmpty {
                Form {
//                    let selectedPadIDs = componentDesignManager.footprintInteraction.selectedIDs
//
//                    ForEach(Array(selectedPadIDs), id: \.self) { padID in
//                        if let binding = componentDesignManager.bindingForPad(with: padID) {
//                            Section("Pad \(binding.wrappedValue.number) Properties") {
//                                PadPropertiesView(pad: binding)
//                            }
//                        }
//                    }
                    Text("Pads")
                }
                .formStyle(.grouped)
                .listStyle(.inset)
            } else {
                Spacer()
                Text("No pads selected")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }

    private func togglePadSelection(pad: Pad) {
//        if let element = componentDesignManager.footprintElements.first(where: {
//            if case .pad(let p) = $0 { return p.id == pad.id } else { return false }
//        }) {
//            let id = element.id
//            componentDesignManager.footprintInteraction.toggleID(id)
//        }
    }
}
