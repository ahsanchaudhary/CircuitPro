import SwiftUI
import Observation

@Observable
class CanvasDragManager<Item, ID: Hashable> {
    
    struct DragState {
        let id: ID
        let startLocation: CGPoint
        var translation: CGSize = .zero
        let initialPosition: SDPoint
    }

    var dragState: DragState?
    private let idProvider: (Item) -> ID

    init(idProvider: @escaping (Item) -> ID) {
        self.idProvider = idProvider
    }

    @discardableResult
    func handleDrag(
        phase: ContinuousGesturePhase,
        location: CGPoint,
        translation: CGSize,
        proxy: AdvancedScrollViewProxy,

        items: [Item],

        /// NEW: per‑call hit test
        hitTest: (Item, CGPoint) -> Bool,

        positionForItem: (Item) -> SDPoint,
        setPositionForItem: @escaping (Item, SDPoint) -> Void,
        snapping: @escaping (CGPoint) -> CGPoint = { $0 }
    ) -> Bool {
        switch phase {
        case .possible:
            return items.reversed().contains { hitTest($0, location) }

        case .began:
            guard let item = items.reversed().first(where: { hitTest($0, location) }) else {
                return false
            }
            dragState = DragState(
                id: idProvider(item),
                startLocation: location,
                translation: .zero,
                initialPosition: positionForItem(item)
            )
            return true

        case .changed:
            guard var s = dragState else { return false }
            let start = CGPoint(x: s.initialPosition.x, y: s.initialPosition.y)
            let moved = CGPoint(x: start.x + translation.width,
                                y: start.y + translation.height)
            let snap = snapping(moved)
            s.translation = CGSize(width: snap.x - start.x,
                                   height: snap.y - start.y)
            dragState = s
            return true

        case .cancelled:
            dragState = nil
            return true

        case .ended:
            guard let s = dragState else { return false }
            defer { dragState = nil }
            let start = CGPoint(x: s.initialPosition.x, y: s.initialPosition.y)
            let moved = CGPoint(x: start.x + translation.width,
                                y: start.y + translation.height)
            let snap = snapping(moved)

            if let item = items.first(where: { idProvider($0) == s.id }) {
                setPositionForItem(item, SDPoint(snap))
                return true
            }
            return false
        }
    }

    func dragOffset(for item: Item) -> CGSize {
        guard let s = dragState, idProvider(item) == s.id else { return .zero }
        return s.translation
    }

    func dragOpacity(for item: Item) -> Double {
        guard let s = dragState, idProvider(item) == s.id else { return 1.0 }
        return 0.75
    }
}
