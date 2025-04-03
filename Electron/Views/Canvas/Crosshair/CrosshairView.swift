//
//  CrosshairView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//
import SwiftUI

struct CrosshairsView: View {
    var body: some View {
        ZStack {
            // Horizontal line
            Capsule()
                .frame(width: 20, height: 2)

            // Vertical line
            Capsule()
                .frame(width: 2, height: 20)
        }
        .foregroundColor(.blue)
        .allowsHitTesting(false)
    }
}



#Preview {
    CrosshairsView()
}
