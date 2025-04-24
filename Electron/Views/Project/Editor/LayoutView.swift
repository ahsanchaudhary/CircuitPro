import SwiftUI

struct TestSymbol: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color = .blue
}

struct LayoutView: View {
    
    @Environment(\.canvasManager) var canvasManager
    
    
    @State private var symbols: [TestSymbol] = [
        TestSymbol(x: -450, y: 100),
        TestSymbol(x: 200, y: 200),
        TestSymbol(x: 3000, y: 3000, color: .purple),
        TestSymbol(x: 0, y: 3000, color: .pink),
        TestSymbol(x: 3000, y: 0, color: .indigo),
        TestSymbol(x: 0, y: 52, color: .red),
        TestSymbol(x: 1500, y: 1500, color: .green)
    ]
    
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(symbols.indices, id: \.self) { index in
                    Text("Tst")
                    
                }
               
            }
            .onTapGesture { location in
                if canvasManager.selectedLayoutTool == .via {
                    let newSymbol = TestSymbol(x: canvasManager.canvasMousePosition.x, y: canvasManager.canvasMousePosition.y)
                    withAnimation {
                        self.symbols.append(newSymbol)
                    }
                    canvasManager.selectedLayoutTool = .cursor
                }
            }
          
            if canvasManager.selectedLayoutTool == .via {
                Image(systemName: LayoutTool.via.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(.red)
//                    .position(canvasManager.transformedMousePosition)
                    .allowsHitTesting(false)
            }
        }

//        .overlay(alignment: .center) {
//            VStack {
//                HStack {
//                    Spacer()
//                    LayoutToolbarView()
//                }
//                Spacer()
//                HStack {
//                    ZoomControlView()
//                    
//                    Spacer()
//                    Button {
//                        withAnimation {
//                            canvasManager.showComponentDrawer.toggle()
//                        }
//                      
//                    } label: {
//                        HStack {
//                            if !canvasManager.showComponentDrawer {
//                                Image(systemName: AppIcons.trayFull)
//                                    .transaction { transaction in
//                                        transaction.animation = nil
//                                    
//                                    }
//                        
//                            }
//                             Text("Component Drawer")
//                               if canvasManager.showComponentDrawer {
//                                   Image(systemName: AppIcons.xmark)
//                                   
//                               }
//                           }
//                        
//                        
//                    }
//             
//                    .buttonStyle(.plain)
//                    .font(.callout)
//                    .fontWeight(.semibold)
//                    .directionalPadding(vertical: 7.5, horizontal: 10)
//                    .background(.ultraThinMaterial)
//                    .clipShape(Capsule())
//              
//
//                    Spacer()
//                    CanvasControlView()
//                    
//                }
//                if canvasManager.showComponentDrawer {
//                    ComponentDrawerView()
//                }
//          
//            }
//            .padding(10)
//        }
    }

}



#Preview {
    LayoutView()
}

