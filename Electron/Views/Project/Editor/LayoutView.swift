import SwiftUI

struct TestSymbol: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color = .blue
}

struct LayoutView: View {
    
    @Environment(\.canvasManager) var canvasManager
    
    let layout: Layout?
    
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
            SwiftUICanvasView {
                ForEach(symbols.indices, id: \.self) { index in
                    DragSymbol(position: $symbols[index], color: $symbols[index].color)
                    
                    
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
                Image(systemName: LayoutTools.via.rawValue)
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

struct DragSymbol: View {
    @Binding var position: TestSymbol
    @Binding var color: Color
    
    @State private var dragOffset = CGSize.zero
    
    @Environment(\.canvasManager) var canvasManager  // Access the canvas manager from the environment

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 10, height: 10)
            .position(x: position.x + dragOffset.width + 5, y: position.y + dragOffset.height + 5)
            
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Compute the tentative new position
                        let newX = position.x + value.translation.width
                        let newY = position.y + value.translation.height
                        if canvasManager.enableSnapping {
                            // Snap the position to the nearest grid point
                            let snappedX = (newX / canvasManager.unitSpacing).rounded() * canvasManager.unitSpacing
                            let snappedY = (newY / canvasManager.unitSpacing).rounded() * canvasManager.unitSpacing
                            // Update dragOffset to reflect the snapped position relative to the base position
                            dragOffset = CGSize(width: snappedX - position.x, height: snappedY - position.y)
                        } else {
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        // Calculate the final new position
                        let newX = position.x + value.translation.width
                        let newY = position.y + value.translation.height
                        if canvasManager.enableSnapping {
                            // Snap the final position to the grid
                            position.x = (newX / canvasManager.unitSpacing).rounded() * canvasManager.unitSpacing
                            position.y = (newY / canvasManager.unitSpacing).rounded() * canvasManager.unitSpacing
                        } else {
                            position.x = newX
                            position.y = newY
                        }
                        // Reset the offset for the next drag
                        dragOffset = .zero
                    }
            )
            
    }
}

#Preview {
    LayoutView(layout: Layout(title: "Unknown", data: Data(), project: .init(name: "Test Project")))
}

