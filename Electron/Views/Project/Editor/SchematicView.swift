import SwiftUI

struct DragState {
    var symbolInstanceUUID: UUID
    var startLocation: CGPoint
    var translation: CGSize = .zero
    var initialPosition: SDPoint
}

struct SchematicView: View {
    
    @Environment(\.projectManager) private var projectManager
    @Environment(\.canvasManager) private var canvasManager

    @State private var dragState: DragState? = nil


    var body: some View {
        NSCanvasView {
            ForEach(projectManager.activeComponentInstances) { instance in

                SymbolView(symbolInstance: instance.symbolInstance)

                    .offset(dragState?.symbolInstanceUUID == instance.symbolInstance.uuid ? dragState!.translation : .zero)
                    .opacity(dragState?.symbolInstanceUUID == instance.symbolInstance.uuid ? 0.75 : 1.0)
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
                // Add instance placement logic here
                canvasManager.selectedSchematicTool = .cursor
            }
        }
        .overlay(alignment: .center) {
            CanvasOverlayView().padding(10)
        }
    }

    private func handleDrag(
        phase: ContinuousGesturePhase,
        location: CGPoint,
        translation: CGSize,
        proxy: AdvancedScrollViewProxy
    ) -> Bool {
        switch phase {
        case .possible:
            return hitTestSymbol(at: location) != nil

        case .began:
            if let index = hitTestSymbol(at: location) {
                let symbol = projectManager.activeComponentInstances[index].symbolInstance
                self.dragState = DragState(
                    symbolInstanceUUID: symbol.uuid,
                    startLocation: location,
                    initialPosition: symbol.position
                )
                return true
            }
            return false

        case .changed:
            // Do not update the underlying symbol's position yet,
            // just update the drag offset.
            guard let currentDragState = self.dragState else {
                return false
            }

            var newPos = CGPoint(
                x: currentDragState.initialPosition.x + translation.width,
                y: currentDragState.initialPosition.y + translation.height
            )

            if canvasManager.enableSnapping {
                newPos = canvasManager.snap(point: newPos)
            }

            // Update only the gesture translation (offset) for feedback.
            self.dragState?.translation = CGSize(
                width: newPos.x - currentDragState.initialPosition.x,
                height: newPos.y - currentDragState.initialPosition.y
            )
            return true

        case .cancelled:
            self.dragState = nil
            return true

        case .ended:
            guard let currentDragState = self.dragState,
                  let index = projectManager.activeComponentInstances.firstIndex(where: { $0.symbolInstance.uuid == currentDragState.symbolInstanceUUID })
            else {
                return false
            }

            var finalPos = CGPoint(
                x: currentDragState.initialPosition.x + translation.width,
                y: currentDragState.initialPosition.y + translation.height
            )

            if canvasManager.enableSnapping {
                finalPos = canvasManager.snap(point: finalPos)
            }

            // Commit the final position to the model.
            projectManager.activeComponentInstances[index].symbolInstance.position = SDPoint(finalPos)
            self.dragState = nil
            return true
        }
    }

    private func hitTestSymbol(at location: CGPoint) -> Int? {
        for index in projectManager.activeComponentInstances.indices.reversed() {
            let symbol = projectManager.activeComponentInstances[index].symbolInstance
            let rect = CGRect(x: symbol.position.x - 15, y: symbol.position.y - 15, width: 30, height: 30)
            if rect.contains(location) {
                return index
            }
        }
        return nil
    }
}

#Preview {
    SchematicView()
}
