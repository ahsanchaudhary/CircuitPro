//
//  SchematicView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//

import SwiftUI



struct SymbolModel: Identifiable {
    let id = UUID()
    var position: CGPoint
    var initialPosition: CGPoint? // To store position at drag start
    var color: Color = .blue
    
    var primitives: [GraphicPrimitiveType] = []
    
    var x: CGFloat { position.x }
    var y: CGFloat { position.y }
}

struct Pin: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color = .blue
    
    
}

// Structure to hold drag state information
struct DragState {
    var symbolId: UUID
    var startLocation: CGPoint // Drag start location in content coordinates
    var translation: CGSize = .zero // Current translation from startLocation
}

struct SchematicView: View {
    
    @Environment(\.canvasManager) var canvasManager
    
    @State private var symbols: [SymbolModel] = [
        SymbolModel(position: .init(x: 100, y: 100)),
        SymbolModel(position: .init(x: 200, y: 200)),
        SymbolModel(position: .init(x: 3000, y: 3000), color: .purple),
        SymbolModel(position: .init(x: 0, y: 3000), color: .pink),
        SymbolModel(position: .init(x: 3000, y: 0), color: .indigo),
        SymbolModel(position: .init(x: 1450, y: 1450), color: .red, primitives: [.line(Line(position: .zero, strokeWidth: 1, color: .init(color: .purple), start: .init(x: 0, y: 0), end: .init(x: 50, y: 50)))]),
        SymbolModel(position: .init(x: 1500, y: 1500), color: .green, primitives: [GraphicPrimitiveType.rectangle(RectanglePrimitive(position: .zero, strokeWidth: 1, color: .init(color: .black), filled: false, size: CGSize(width: 20, height: 10), cornerRadius: .zero)),
            GraphicPrimitiveType.line(Line(position: .zero, strokeWidth: 1, color: .init(color: .black), start: CGPoint(x: 10, y: 0), end: CGPoint(x: 20, y: 0))),
            GraphicPrimitiveType.line(Line(position: .zero, strokeWidth: 1, color: .init(color: .black), start: CGPoint(x: -10, y: 0), end: CGPoint(x: -20, y: 0)))
                                                            ]),
        SymbolModel(position: .init(x: 1550, y: 1550), primitives: [GraphicPrimitiveType.arc(ArcPrimitive(position: .zero, strokeWidth: 1, color: .init(color: .teal), radius: 50, startAngle: 270, endAngle: 90, clockwise: true))])
    ]


    // State to manage the drag operation
    @State private var dragState: DragState? = nil
    

    var body: some View {
        
        NSCanvasView {
            ForEach(symbols.indices, id: \.self) { index in

                SymbolView(symbol: symbols[index])

                    .opacity(dragState?.symbolId == symbols[index].id ? 0.75 : 1.0)
                    .offset(dragState?.symbolId == symbols[index].id ? dragState!.translation : .zero)
                
          
            }
            if canvasManager.selectedSchematicTool == .noconnect {
                Image(systemName: SchematicTools.noconnect.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                    .position(canvasManager.canvasMousePosition)
                    .allowsHitTesting(false)
            }
        }

      
       
        .onDragContentGesture { phase, location, translation, proxy in
            handleDrag(phase: phase, location: location, translation: translation, proxy: proxy)
        }
        .onTapContentGesture { location, proxy in
            print("Canvas tapped at \(location)")
            if canvasManager.selectedSchematicTool == .noconnect {
                let newSymbol = SymbolModel(position: CGPoint(x: canvasManager.canvasMousePosition.x, y: canvasManager.canvasMousePosition.y))

                    self.symbols.append(newSymbol)

                canvasManager.selectedSchematicTool = .cursor
            }
        }
    
        .overlay(alignment: .center) {
            CanvasOverlayView()
                .padding(10)
               
        }
      
  
       
    }

    // Drag handling logic extracted for clarity
    private func handleDrag(phase: ContinuousGesturePhase, location: CGPoint, translation: CGSize, proxy: AdvancedScrollViewProxy) -> Bool {

        switch phase {
        case .possible:
            // Check if the drag starts on any symbol. If yes, allow the drag.
            return hitTestSymbol(at: location) != nil

        case .began:
            // Find which symbol was hit (if any)
            if let hitIndex = hitTestSymbol(at: location) {
                let symbolId = symbols[hitIndex].id
                // Store initial state for the drag
                symbols[hitIndex].initialPosition = CGPoint(x: symbols[hitIndex].x, y: symbols[hitIndex].y)
                dragState = DragState(symbolId: symbolId, startLocation: location)
                print("Began dragging symbol: \(symbolId)")
                return true // We are handling this drag
            }
            return false // Didn't start on a symbol, don't handle it (allow default pan)

        case .changed:
            guard let dragState = dragState,
                  let index = symbols.firstIndex(where: { $0.id == dragState.symbolId }),
                  let initial = symbols[index].initialPosition else {
                return false
            }

            var newPos = CGPoint(x: initial.x + translation.width,
                                 y: initial.y + translation.height)

            if canvasManager.enableSnapping {
                newPos = canvasManager.snap(point: newPos)
            }

            self.dragState?.translation = CGSize(width: newPos.x - initial.x,
                                                 height: newPos.y - initial.y)
            return true


        case .cancelled:
            print("Drag cancelled")
            // Reset the position to initial state if cancelled
            if let draggedId = dragState?.symbolId, let index = symbols.firstIndex(where: { $0.id == draggedId }) {
                 if let initialPos = symbols[index].initialPosition {
                     symbols[index].position.x = initialPos.x
                     symbols[index].position.y = initialPos.y
                 }
                 symbols[index].initialPosition = nil // Clear temp state
            }
            dragState = nil // Clear drag state
            return true

        case .ended:
            print("Drag ended")
            if let draggedId = dragState?.symbolId,
               let index = symbols.firstIndex(where: { $0.id == draggedId }),
               let initial = symbols[index].initialPosition {

                var finalPos = CGPoint(x: initial.x + translation.width, y: initial.y + translation.height)
                    print("Translation: \(translation), FinalPos: \(finalPos)")
                    if canvasManager.enableSnapping {
                        finalPos = canvasManager.snap(point: finalPos)
                    }
                symbols[index].position.x = finalPos.x
                symbols[index].position.y = finalPos.y
                symbols[index].initialPosition = nil
            }
            dragState = nil
            return true


        }
    }



    private func hitTestSymbol(at location: CGPoint) -> Int? {
        for index in symbols.indices.reversed() {
            let symbol = symbols[index]
            let symbolCenter = CGPoint(x: symbol.x, y: symbol.y)
            
            if symbol.primitives.isEmpty {
                // Fallback: default hit area if no primitives are defined.
                let defaultRect = CGRect(x: symbol.x - 15, y: symbol.y - 15, width: 30, height: 30)
                if defaultRect.contains(location) {
                    return index
                }
            } else {
                // For each primitive, perform system-based hit testing.
                for primitive in symbol.primitives {
                    if primitive.systemHitTest(at: location, symbolCenter: symbolCenter, tolerance: 5.0) {
                        return index
                    }
                }
            }
        }
        return nil
    }
}



#Preview {
    SchematicView()
}
