//
//  AutocompleteDropdown.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/17/25.
//


import SwiftUI

struct AutocompleteDropdown: View {
    
    
    
    @State private var text = ""
    @State private var isDropdownVisible = false
    @FocusState private var isFocused: Bool

    let options: [String]

    private var filteredOptions: [String] {
        // Show all when empty, otherwise filter
        guard !text.isEmpty else { return options }
        return options.filter { $0.lowercased().contains(text.lowercased()) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("Type something…", text: $text)
                .textFieldStyle(.roundedBorder)
                .frame(width: 250)
                .focused($isFocused)
                // whenever we gain focus, show the list
                .onChange(of: isFocused) { focused, _ in
                    isDropdownVisible = focused
                }
                // if we type, only keep it visible when there are matches
                .onChange(of: text) { _, _ in
                    isDropdownVisible = isFocused && !filteredOptions.isEmpty
                }
                .onSubmit {
                    isDropdownVisible = false
                }
                .popover(isPresented: $isDropdownVisible,
                         attachmentAnchor: .rect(.bounds),
                         arrowEdge: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredOptions, id: \.self) { option in
                            Text(option)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    text = option
                                    isDropdownVisible = false
                                    isFocused = false
                                }
                        }
                    }
                    .frame(width: 250,
                           height: min(CGFloat(filteredOptions.count) * 28, 200))
                    .padding(.vertical, 4)
                }

            // …other content here…
        }
    }
}
