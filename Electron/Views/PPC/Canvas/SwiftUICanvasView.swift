//
//  SwiftUICanvasView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI



struct SwiftUICanvasView<Content: View>: View {
    let content: () -> Content
    

    @State private var canvasSize: CGSize = CGSize(width: 3000, height: 3000)

    
    var body: some View {

            ScrollView {
                ZStack {
                    
                    content()
                    
                    
                }
                .border(.blue)
                
                
                
                
                
                
            }
        
        


    }
    
    
  

}

#Preview {
    SwiftUICanvasView {
        Text("hello canvas")
            .position(x: 1000, y: 1000)
    }
}
