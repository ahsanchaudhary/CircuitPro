//
//  CrosshairView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//
import SwiftUI

struct CrosshairsView: View {
    
    @Environment(\.scrollViewManager) private var scrollViewManager
    
    var adaptiveSize: CGFloat {
        return 1/scrollViewManager.currentMagnification
    }
    
    var body: some View {
        ZStack {
            // Horizontal line
            Capsule()
                .frame(width: 20, height: 2)

            // Vertical line
            Capsule()
                .frame(width: 2, height: 20)
        }
        .scaleEffect(adaptiveSize, anchor: .center)
        .foregroundColor(.blue)
        .allowsHitTesting(false)
    }
}



#Preview {
    CrosshairsView()
}
