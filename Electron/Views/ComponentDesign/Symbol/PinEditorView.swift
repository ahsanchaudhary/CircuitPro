//
//  PinEditorView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/2/25.
//

import SwiftUI

struct PinEditorView: View {
    
    @Environment(\.componentDesignManager) private var componentDesignManager
    
    let pins: [Pin]
    @Binding var selectedPins: [Pin]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Pins")
                    .font(.headline)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // Show all pins
                        ForEach(pins) { pin in
                            let isSelected = selectedPins.contains(where: { $0.id == pin.id })
                            Text(pin.label)
                            
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .directionalPadding(vertical: 5, horizontal: 7.5)
                                .background(isSelected ? .gray.opacity(0.3) : .gray.opacity(0.1))
                                .clipShape(.rect(cornerRadius: 5))
                                .onTapGesture {
                                   togglePinSelection(pin: pin)
                                }
                        }
                    }
                }
                .scrollClipDisabled()
                
            }
            .padding(10)
            .border(edge: .bottom, color: .gray.opacity(0.3))
            
            
            Group {
                if selectedPins.isNotEmpty {
                    Form {
                        
                        let selectedPinIDs = componentDesignManager.symbolInteraction.selectedIDs

                        ForEach(Array(selectedPinIDs), id: \.self) { pinID in
                            if let binding = componentDesignManager.bindingForPin(with: pinID) {
                                Section("Pin \(binding.wrappedValue.number) Properties") {
                                    PinPropertiesView(pin: binding)
                                }
                            }
                        }
                    }
                    .formStyle(.grouped)
                    .listStyle(.inset)
           
                    
                    
                } else {
                    Spacer()
                    Text("No pins selected")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .transition(.identity)
            
        }
        
        .frame(maxHeight: .infinity)
        .clipAndStroke(with: RoundedRectangle(cornerRadius: 15))
   
    }
    
    
    private func togglePinSelection(pin: Pin) {
    // Find the corresponding CanvasElement for this Pin
        if let element = componentDesignManager.symbolElements.first(where: {
            if case .pin(let p) = $0 { return p.id == pin.id } else { return false }
        }) {
            let id = element.id
            // Use the manager to toggle selection state
            componentDesignManager.symbolInteraction.toggleID(id)
        }
    }
}
