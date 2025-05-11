//
//  CanvasTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

protocol CanvasTool: Hashable {
    /// Unique key, e.g. "line", "pin", "circle"
    var id: String { get }
    
    /// SF Symbol name for toolbar
    var symbolName: String { get }
    
    /// Human label
    var label: String { get }
    
    /// Called on tap. Return whatever element (primitive or pin) you want to add.
    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement?

    
    associatedtype Preview: View
    /// Mouse‐move preview
    @ViewBuilder
    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> Preview
}

extension CanvasTool {
    mutating func handleTap(at location: CGPoint) -> CanvasElement? {
        handleTap(at: location, context: CanvasToolContext())
    }
}

extension CanvasTool {
    @ViewBuilder
    func preview(mousePosition: CGPoint) -> Preview {
        preview(mousePosition: mousePosition, context: CanvasToolContext())
    }
}




struct AnyCanvasTool: CanvasTool {
    // pick AnyView for our associatedtype
    typealias Preview = AnyView
    
    let id: String
    let symbolName: String
    let label: String
    
    // two closures that capture a boxed copy of the real tool
    private let _handleTap: (CGPoint, CanvasToolContext) -> CanvasElement?
    private let _preview: (CGPoint, CanvasToolContext) -> AnyView

    
    init<T: CanvasTool>(_ tool: T) {
        self.id         = tool.id
        self.symbolName = tool.symbolName
        self.label      = tool.label
        
        // we need a mutable box of our tool so the "mutating" handleTap can change it
        var box = tool
        
        // each time handleTap is called, we pass-through to box.handleTap,
        // then update box in-place so subsequent calls see the new state.
        self._handleTap = { loc, context in
            let result = box.handleTap(at: loc, context: context)
            return result
        }
        
        // preview just forwards to box.preview(...)
        self._preview = { pt, context in
            AnyView(box.preview(mousePosition: pt, context: context))
        }

    }
    
    // conforming to CanvasTool
    mutating func handleTap(at location: CGPoint, context: CanvasToolContext) -> CanvasElement? {
        _handleTap(location, context)
    }
    
    func preview(mousePosition: CGPoint, context: CanvasToolContext) -> AnyView {
        _preview(mousePosition, context)
    }

    
    // Hashable by id
    static func == (a: AnyCanvasTool, b: AnyCanvasTool) -> Bool {
        a.id == b.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CanvasToolContext {
    var existingPinCount: Int = 0

}



enum CanvasToolRegistry {
    static let base: [AnyCanvasTool] = [
        AnyCanvasTool(CursorTool())
    ]
    static let graphicsTools: [AnyCanvasTool] = [
        AnyCanvasTool(LineTool()),
        AnyCanvasTool(RectangleTool()),
        AnyCanvasTool(CircleTool())
    ]
    
    static let symbolDesignTools: [AnyCanvasTool] =
       base + graphicsTools + [AnyCanvasTool(PinTool())]
    
    static let footprintDesignTools: [AnyCanvasTool] =
    base + graphicsTools + [AnyCanvasTool(PadTool())]
}
