//
//  FootprintDesignView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/7/25.
//

import SwiftUI

struct FootprintDesignView: View {
    @Environment(CanvasManager.self) private var canvasManager
    @Environment(\.componentDesignManager) private var componentDesignManager

    var body: some View {
        @Bindable var manager = componentDesignManager

        let selectedPrimitiveID = componentDesignManager.footprintInteraction.soleSelectedPrimitiveID(from: componentDesignManager.footprintElements)

        NSCanvasView {
            // Render every CanvasElement
            ForEach(Array(componentDesignManager.footprintElements.enumerated()), id: \.element.id) { idx, _ in
                CanvasElementView(
                    element: $manager.footprintElements[idx],
                    isSelected: componentDesignManager.footprintInteraction.selectedIDs.contains(componentDesignManager.footprintElements[idx].id),
                    selectedPrimitiveID: selectedPrimitiveID,
                    offset: componentDesignManager.footprintInteraction.dragManager.dragOffset(for: componentDesignManager.footprintElements[idx]),
                    alpha: componentDesignManager.footprintInteraction.dragManager.dragOpacity(for: componentDesignManager.footprintElements[idx])
                )
            }
            // Preview of whatever tool is active
            if let tool = componentDesignManager.selectedFootprintTool {
                tool.preview(mousePosition: canvasManager.canvasMousePosition, context: .init(existingPinCount: componentDesignManager.allPins.count))
            }

        }

        // MARK: Tap → selection vs placement
        .onTapContentGesture { location, _ in
            let loc = canvasManager.canvasMousePosition
            let mods = EventModifiers(from: NSApp.currentEvent?.modifierFlags ?? [])

            if componentDesignManager.selectedFootprintTool?.id == "cursor" {
                // selection
                componentDesignManager.footprintInteraction.tap(
                    at: location,
                    items: componentDesignManager.footprintElements,
                    hitTest: { elem, pt in
                        switch elem {
                        case .pad(let pad):
                            return pad.systemHitTest(at: pt)
                        default:
                            return false
                        }
                    },
                    drawToolActive: false,
                    modifiers: mods
                )
            } else {
                // placement
                guard var tool = componentDesignManager.selectedFootprintTool else { return }
                if let e = tool.handleTap(at: loc, context: .init(existingPinCount: componentDesignManager.allPins.count - 1)) {
                    withAnimation {
                        componentDesignManager.footprintElements.append(e)
                    }
                }
                componentDesignManager.selectedFootprintTool = tool
            }
        }

        // MARK: Drag → move, marquee, or handle
        .onDragContentGesture { phase, location, translation, proxy in
            let (edit, didHandle) = componentDesignManager.footprintInteraction.drag(
                phase: phase,
                location: location,
                translation: translation,
                proxy: proxy,
                items: componentDesignManager.footprintElements,
                hitTest: { elem, pt in
                    switch elem {
                    case .pad(let pad):
                        return pad.systemHitTest(at: pt)
                    default:
                        return false
                    }
                },
                positionForItem: { elem in
                    switch elem {
                    case .pad(let pad):     return pad.position
                    default:
                        return .init(.zero)
                    }
                },
                setPositionForItem: { elem, newPos in
                    guard let i = componentDesignManager.footprintElements.firstIndex(where: { $0.id == elem.id }) else { return }
                    switch elem {
                    case .pad(var pad):
                        pad.position = newPos
                        componentDesignManager.footprintElements[i] = .pad(pad)
                    default:
                        return
                    }
                },
                snapping: canvasManager.enableSnapping ? canvasManager.snap : { $0 }
            )

            // Apply the handle mutation if any
            if let edit = edit {
                componentDesignManager.footprintElements[edit.elementIndex] = edit.newElement
            }
            // Always return didHandle (ensures marquee/drag remain responsive)
            return didHandle
        }
        .clipAndStroke(with: .rect(cornerRadius: 20))
        .overlay {
            CanvasOverlayView(enableComponentDrawer: false) {
                FootprintDesignToolbarView()
            }
            .padding(10)
        }
    }
}

