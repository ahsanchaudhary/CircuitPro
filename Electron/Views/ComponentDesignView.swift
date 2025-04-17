//
//  ComponentDesignView.swift
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
                .onChange(of: isFocused) { focused in
                    isDropdownVisible = focused
                }
                // if we type, only keep it visible when there are matches
                .onChange(of: text) { _ in
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





struct ComponentDesignView: View {
    
    @State private var componentName: String = ""
    @State private var selectedCategory: ComponentCategory?
    @State private var componentProperties: [ComponentProperty] = [ComponentProperty(name: "Capacitance", value: .range(min: 10, max: 100), unit: .init(prefix: .giga, base: .farad), warnsOnEdit: true), ComponentProperty(name: "Resistance", value: .single(100), unit: .init(prefix: .giga, base: .farad), warnsOnEdit: true)]
    
    @State private var selected = ""
    
    var body: some View {
        VStack {
            componentDetails
   
        }
        .navigationTitle("Component Designer")
    }
    
    
    var componentDetails: some View {
        VStack {
            componentDesignSection("Component Name") {
                TextField("e.g. Resistor, Capacitor, LED", text: $componentName)
                
            }
         
         
         
            componentDesignSection("Category") {
                Picker("", selection: $selectedCategory) {
                    Text("Select a Category").tag(nil as ComponentCategory?)
                    
                    ForEach(ComponentCategory.allCases) { category in
                        Text(category.label).tag(Optional(category))
                    }
                }
                .pickerStyle(.menu)


            }
            componentDesignSection("Properties") {
                ComponentPropertyView(componentProperties: $componentProperties)
            }
      
        }

    }
    
    var componentSymbol: some View {
        Text("Component Symbol")
    }
    
    func componentDesignSection<Content: View>(_ title: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
             if let title {
                 Text(title)
                     .font(.subheadline)
                     .foregroundStyle(.secondary)
                     .fontWeight(.semibold)
                     .padding(5)
            }
    
            
            content()
        }
    }

}

#Preview {
    ComponentDesignView()
}
