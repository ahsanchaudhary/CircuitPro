import SwiftUI
import SwiftData

struct SchematicView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.projectManager) private var projectManager
    @Environment(\.canvasManager) private var canvasManager

    // 1️⃣ Our drag manager (no hitTest baked in here)
    @State private var dragManager =
      CanvasDragManager<ComponentInstance, UUID>(idProvider: { $0.uuid })

    // 2️⃣ A simple cache of loaded Symbols by UUID
    @State private var symbolCache: [UUID: Symbol] = [:]

    var body: some View {
        NSCanvasView {
        
           
            
            ForEach(projectManager.activeComponentInstances) { inst in
               // Pull primitives out of your cache, or empty if missing
               let primitives = symbolCache[inst.symbolInstance.symbolUUID]?.primitives ?? []
               
               SymbolView(
                 symbolInstance: inst.symbolInstance,
                 primitives: primitives
               )
               .offset(dragManager.dragOffset(for: inst))
               .opacity(dragManager.dragOpacity(for: inst))
             }

            if canvasManager.selectedSchematicTool == .noconnect {
                Image(systemName: SchematicTool.noconnect.rawValue)
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                    .position(canvasManager.canvasMousePosition)
                    .allowsHitTesting(false)
            }
        }
        // 3️⃣ Handle dragging, supplying our custom hitTest that uses the cache
        .onDragContentGesture { phase, location, translation, proxy in
            dragManager.handleDrag(
                phase: phase,
                location: location,
                translation: translation,
                proxy: proxy,
                items: projectManager.activeComponentInstances,

                // ↪️ New: a per-call hitTest closure
                hitTest: { instance, tap in
                    let center = CGPoint(
                        x: instance.symbolInstance.position.x,
                        y: instance.symbolInstance.position.y
                    )

                    // Fallback rect if no primitives
                    let rect = CGRect(
                        x: center.x - 15,
                        y: center.y - 15,
                        width: 30,
                        height: 30
                    )

                    // Grab primitives from cache (empty if not found)
                    let primitives = symbolCache[instance.symbolInstance.symbolUUID]?.primitives ?? []

                    guard !primitives.isEmpty else {
                        return rect.contains(tap)
                    }
                    // Otherwise test each primitive path
                    for prim in primitives.reversed() {
                        if prim.systemHitTest(
                            at: tap,
                            symbolCenter: center,
                            tolerance: 5.0
                        ) {
                            return true
                        }
                    }
                    return false
                },

                positionForItem: { $0.symbolInstance.position },
                setPositionForItem: { inst, newSD in
                    inst.symbolInstance.position = newSD
                }, selectedIDs: [],
                snapping: canvasManager.enableSnapping
                          ? canvasManager.snap
                          : { $0 }
            )
        }
        // 4️⃣ Preload all symbols once on appear/task
        .overlay {
            CanvasOverlayView()
                .padding(10)
        }
        .task {
            let descriptors = projectManager.activeComponentInstances
                .map(\.symbolInstance.symbolUUID)
                .reduce(into: Set<UUID>()) { $0.insert($1) }
                .map { uuid in
                    FetchDescriptor<Symbol>(
                        predicate: #Predicate { $0.uuid == uuid },
                        sortBy: []
                    )
                }
            for desc in descriptors {
                if let sym = try? context.fetch(desc).first {
                    symbolCache[sym.uuid] = sym
                }
            }
        }
    }
}



#Preview {
    SchematicView()
}
