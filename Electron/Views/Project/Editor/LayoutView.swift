import SwiftUI

struct TestSymbol: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
}

struct LayoutView: View {
    
    @Environment(\.canvasManager) var canvasManager
    @State private var symbols: [TestSymbol] = [
        TestSymbol(x: 100, y: 100),
        TestSymbol(x: 200, y: 200)
    ]
    
    
    var body: some View {
        CanvasView {
            ForEach(symbols.indices, id: \.self) { index in
                DragSymbol(position: $symbols[index])
                   
            }
        }

        .overlay(alignment: .center) {
            VStack {
                HStack {
                    Spacer()
                    LayoutToolbarView()
                }
                Spacer()
                HStack {
                    ZoomControlView()
                    
                    Spacer()
                    Button {
                        withAnimation {
                            canvasManager.showComponentDrawer.toggle()
                        }
                      
                    } label: {
                        HStack {
                            if !canvasManager.showComponentDrawer {
                                Image(systemName: AppIcons.trayFull)
                                    .transaction { transaction in
                                        transaction.animation = nil
                                    
                                    }
                        
                            }
                             Text("Component Drawer")
                               if canvasManager.showComponentDrawer {
                                   Image(systemName: AppIcons.xmark)
                                   
                               }
                           }
                        
                        
                    }
             
                    .buttonStyle(.plain)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .directionalPadding(vertical: 7.5, horizontal: 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
              

                    Spacer()
                    CanvasControlView()
                    
                }
                if canvasManager.showComponentDrawer {
                    ComponentDrawerView()
                }
          
            }
            .padding(10)
        }
    }

}

struct DragSymbol: View {
    @Binding var position: TestSymbol
    @State private var dragOffset = CGSize.zero
    @Environment(\.canvasManager) var canvasManager  // Access the canvas manager from the environment

    // Define a grid size for snapping (adjust as needed)
    private let gridSize: CGFloat = 20

    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 30, height: 30)
            .position(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
            
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Compute the tentative new position
                        let newX = position.x + value.translation.width
                        let newY = position.y + value.translation.height
                        if canvasManager.enableSnapping {
                            // Snap the position to the nearest grid point
                            let snappedX = (newX / gridSize).rounded() * gridSize
                            let snappedY = (newY / gridSize).rounded() * gridSize
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
                            position.x = (newX / gridSize).rounded() * gridSize
                            position.y = (newY / gridSize).rounded() * gridSize
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
    LayoutView()
}


#Preview {
    LayoutView()
}
