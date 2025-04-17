//
//  NewsListView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/17/25.
//

import SwiftUI

struct NewsListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    private var newsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0..<5) { _ in
                    newsCard
                }
            }
            .padding()
        }

 
    }
    
    private var newsCard: some View {
    
            Image("GradientTest")
            
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .aspectRatio(contentMode: .fit)
            
        
        .frame(height: 200)
        .overlay(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("Content Title")
                    .font(.headline)
                Text("Content Text, This will be a long text htat gives preview of what the content is about.")
                    .font(.subheadline)
            }
            .directionalPadding(vertical: 10, horizontal: 5)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            
        
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(5)
        }
    
    }
}

#Preview {
    NewsListView()
}
