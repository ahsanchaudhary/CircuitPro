//
//  PropertyColumn.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/21/25.
//

import SwiftUI

struct PropertyColumn: View {
    @Binding var property: ComponentProperty
    
    var body: some View {
        TextField("Name", text: $property.name)
    }
}
