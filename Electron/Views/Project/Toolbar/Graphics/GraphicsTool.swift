//
//  GraphicsTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI


protocol GraphicsTool {
  associatedtype Preview: View

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType?
  
  @ViewBuilder
  func preview(mousePosition: CGPoint) -> Preview
}

import SwiftUI

struct CursorTool<ID: Hashable> {
    private(set) var selectedIDs: Set<ID> = []
    var marqueeTool = MarqueeTool<ID>()
    
    mutating func handleTap<Item: Identifiable>(
        at location: CGPoint,
        in items: [Item],
        hitTest: (Item, CGPoint) -> Bool,
        modifiers: EventModifiers
    ) where Item.ID == ID {
        if let hit = items.reversed().first(where: { hitTest($0, location) }) {
            let id = hit.id
            if modifiers.contains(.shift) {
                toggleSelection(of: id)
            } else {
                selectOnly(id)
            }
        } else {
            if !modifiers.contains(.shift) {
                clearSelection()
            }
        }
    }
    
    mutating func handleDragPossible<Item: Identifiable>(
        at location: CGPoint,
        in items: [Item],
        hitTest: (Item, CGPoint) -> Bool
    ) -> Bool where Item.ID == ID {
        // Return true if drag should be marquee, false if dragging an item
        return !items.reversed().contains { hitTest($0, location) }
    }
    
    mutating func beginMarquee(at location: CGPoint) {
        marqueeTool.begin(at: location)
    }
    
    mutating func updateMarquee(to location: CGPoint) {
        marqueeTool.update(to: location)
    }
    
    mutating func endMarquee<Item: Identifiable>(
        items: [Item],
        positionForItem: (Item) -> CGPoint,
        modifiers: EventModifiers
    ) where Item.ID == ID {
        marqueeTool.endSelection(
            items: items,
            positionForItem: positionForItem,
            setSelection: { ids in
                if modifiers.contains(.shift) {
                    selectedIDs.formUnion(ids)
                } else {
                    selectedIDs = Set(ids)
                }
            },
            modifiers: modifiers
        )
    }
    
    mutating func cancelMarquee() {
        marqueeTool.cancel()
    }
    
    @ViewBuilder
    func overlay() -> some View {
        marqueeTool.marqueeOverlay()
    }
    
    private mutating func toggleSelection(of id: ID) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }
    
    private mutating func selectOnly(_ id: ID) {
        selectedIDs = [id]
    }
    
    private mutating func clearSelection() {
        selectedIDs.removeAll()
    }
    
    func isSelected(_ id: ID) -> Bool {
        selectedIDs.contains(id)
    }
}

import SwiftUI

struct MarqueeTool<ID: Hashable> {
    var start: CGPoint?
    var end: CGPoint?
    var isActive: Bool = false

    var currentRect: CGRect? {
        guard let start, let end else { return nil }
        return CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
    }
    
    mutating func begin(at location: CGPoint) {
        start = location
        end = location
        isActive = true
    }
    
    mutating func update(to location: CGPoint) {
        end = location
    }
    
    mutating func endSelection<Item: Identifiable>(
        items: [Item],
        positionForItem: (Item) -> CGPoint,
        setSelection: (_ selectedIDs: [ID]) -> Void,
        modifiers: EventModifiers
    ) where Item.ID == ID {
        guard let rect = currentRect else {
            reset()
            return
        }
        
        let selected = items.filter { rect.contains(positionForItem($0)) }.map(\.id)
        
        setSelection(selected)
        reset()
    }
    
    mutating func cancel() {
        reset()
    }
    
    @ViewBuilder
    func marqueeOverlay() -> some View {
        if let rect = currentRect {
            Path { path in
                path.addRect(rect)
            }
            .stroke(Color.blue, lineWidth: 1)
            .background(
                Path { path in
                    path.addRect(rect)
                }
                .fill(Color.blue.opacity(0.1))
            )
            .allowsHitTesting(false)
        }
    }
    
    private mutating func reset() {
        start = nil
        end = nil
        isActive = false
    }
}
