import SwiftUI

struct SymbolDesignView: View {
    @Environment(\.canvasManager) private var canvasManager
    @Environment(\.componentDesignManager) private var componentDesignManager

    var body: some View {
        @Bindable var manager = componentDesignManager

        let selectedPrimitiveID = componentDesignManager.symbolInteraction.soleSelectedPrimitiveID(from: componentDesignManager.symbolElements)

        NSCanvasView {
            // Render every CanvasElement
            ForEach(Array(componentDesignManager.symbolElements.enumerated()), id: \.element.id) { idx, _ in
                CanvasElementView(
                    element: $manager.symbolElements[idx],
                    isSelected: componentDesignManager.symbolInteraction.selectedIDs.contains(componentDesignManager.symbolElements[idx].id),
                    selectedPrimitiveID: selectedPrimitiveID,
                    offset: componentDesignManager.symbolInteraction.dragManager.dragOffset(for: componentDesignManager.symbolElements[idx]),
                    alpha: componentDesignManager.symbolInteraction.dragManager.dragOpacity(for: componentDesignManager.symbolElements[idx])
                )
            }
            // Preview of whatever tool is active
            if let tool = componentDesignManager.selectedTool {
                tool.preview(mousePosition: canvasManager.canvasMousePosition, context: .init(existingPinCount: componentDesignManager.allPins.count))
            }

        }

        // MARK: Tap → selection vs placement
        .onTapContentGesture { location, _ in
            let loc = canvasManager.canvasMousePosition
            let mods = EventModifiers(from: NSApp.currentEvent?.modifierFlags ?? [])

            if componentDesignManager.selectedTool?.id == "cursor" {
                // selection
                componentDesignManager.symbolInteraction.tap(
                    at: location,
                    items: componentDesignManager.symbolElements,
                    hitTest: { elem, pt in
                        switch elem {
                        case .primitive(let p):
                            return p.systemHitTest(at: pt, symbolCenter: .zero)
                        case .pin(let pin):
                            return pin.systemHitTest(at: pt)
                        default:
                            return false
                        }
                    },
                    drawToolActive: false,
                    modifiers: mods
                )
            } else {
                // placement
                guard var tool = componentDesignManager.selectedTool else { return }
                if let e = tool.handleTap(at: loc, context: .init(existingPinCount: componentDesignManager.allPins.count - 1)) {
                    withAnimation {
                        componentDesignManager.symbolElements.append(e)
                    }
                }
                componentDesignManager.selectedTool = tool
            }
        }

        // MARK: Drag → move, marquee, or handle
        .onDragContentGesture { phase, location, translation, proxy in
            let (edit, didHandle) = componentDesignManager.symbolInteraction.drag(
                phase: phase,
                location: location,
                translation: translation,
                proxy: proxy,
                items: componentDesignManager.symbolElements,
                hitTest: { elem, pt in
                    switch elem {
                    case .primitive(let p):
                        return p.systemHitTest(at: pt, symbolCenter: .zero)
                    case .pin(let pin):
                        return pin.systemHitTest(at: pt)
                    default:
                        return false
                    }
                },
                positionForItem: { elem in
                    switch elem {
                    case .primitive(let p): return SDPoint(p.position)
                    case .pin(let pin):     return pin.position
                    default:
                        return .init(.zero)
                    }
                },
                setPositionForItem: { elem, newPos in
                    guard let i = componentDesignManager.symbolElements.firstIndex(where: { $0.id == elem.id }) else { return }
                    switch elem {
                    case .primitive(var p):
                        p.position = CGPoint(x: newPos.x, y: newPos.y)
                        componentDesignManager.symbolElements[i] = .primitive(p)
                    case .pin(var pin):
                        pin.position = newPos
                        componentDesignManager.symbolElements[i] = .pin(pin)
                    default:
                        return
                    }
                },
                snapping: canvasManager.enableSnapping ? canvasManager.snap : { $0 }
            )

            // Apply the handle mutation if any
            if let edit = edit {
                componentDesignManager.symbolElements[edit.elementIndex] = edit.newElement
            }
            // Always return didHandle (ensures marquee/drag remain responsive)
            return didHandle
        }
        .clipAndStroke(with: .rect(cornerRadius: 20))
        .overlay {
            CanvasOverlayView(enableComponentDrawer: false) {
                SymbolDesignToolbarView()
            }
            .padding(10)
        }
    }
}

