import SwiftUI



struct NSCanvasView<Content: View>: View {
    
    
    // Content closure provided by the user
    @ViewBuilder var content: () -> Content
    @Environment(\.scrollViewManager) var model
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.projectManager) private var projectManager
    @Environment(CanvasManager.self) private var canvasManager
    
    
    // --- Stored Gesture Actions ---
    private var onTapAction: TapContentAction? = nil
    private var tapGestureCount: Int = 1
    private var onDragAction: DragContentAction? = nil
    
    @State private var zoom: CGFloat = 1
    
    @State private var isDropTargeted: Bool = false

    
    // --- Internal Initializer (Used by modifiers) ---
    // Needs to copy all configurable properties
    private init(
        content: @escaping () -> Content,
        onTapAction: TapContentAction?,
        tapGestureCount: Int,
        onDragAction: DragContentAction?
    ) {
        self.content = content
        self.onTapAction = onTapAction
        self.tapGestureCount = tapGestureCount
        self.onDragAction = onDragAction
    }
    
    // --- Public Initializer ---
    init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        
        // Initialize gesture actions to nil
        self.onTapAction = nil
        self.tapGestureCount = 1
        self.onDragAction = nil
    }
    
    
    var body: some View {
        // Create the AdvancedScrollView instance
        var scrollView = AdvancedScrollView {
            
            
            ZStack {
                
                CanvasBackgroundView()
                
                content()
                
                
            }
            .frame(width: canvasManager.canvasSize.width, height: canvasManager.canvasSize.height)
            
            .dropDestination(for: TransferableComponent.self) { components, location in
                guard let component = components.first,
                      let design = projectManager.selectedDesign else {
                    return false
                }

                let locationInCanvas = if canvasManager.enableSnapping { canvasManager.snap(location) } else { location }
                let symbolInstance = SymbolInstance(symbolId: component.symbolUUID, position: SDPoint(locationInCanvas))

                let componentInstance = ComponentInstance(
                    componentId: component.componentUUID,
                    symbolInstance: symbolInstance,
                    design: design // ✅ explicitly set the inverse relationship
                )

                modelContext.insert(componentInstance)
                design.componentInstances.append(componentInstance) // ✅ maintain array consistency

                print("Dropped component:", component.componentUUID)
                print("At location:", location)

                return true
            }



            .border(Color.gray.opacity(0.1), width: 1)
            
            
        }
        
        
        // Apply the tap gesture if provided
        if let tapAction = onTapAction {
            scrollView = scrollView.onTapContentGesture(count: tapGestureCount, perform: tapAction)
        }
        
        // Apply the drag gesture if provided
        if let dragAction = onDragAction {
            scrollView = scrollView.onDragContentGesture(perform: dragAction)
        }
        
        return scrollView
        
        
    }
    
    // --- Custom Modifiers for CanvasView ---
    
    /// Sets the action to perform when the content area is tapped.
    func onTapContentGesture(count: Int = 1, perform action: @escaping TapContentAction) -> NSCanvasView {
        // Create a new CanvasView, copying existing state and adding the tap action
        NSCanvasView(
            content: self.content,
            onTapAction: action, // Set the tap action
            tapGestureCount: count, // Set the tap count
            onDragAction: self.onDragAction // Keep existing drag action
        )
    }
    
    /// Sets the action to perform when the content area is dragged.
    func onDragContentGesture(perform action: @escaping DragContentAction) -> NSCanvasView {
        // Create a new CanvasView, copying existing state and adding the drag action
        NSCanvasView(
            content: self.content,
            onTapAction: self.onTapAction, // Keep existing tap action
            tapGestureCount: self.tapGestureCount, // Keep existing tap count
            onDragAction: action // Set the drag action
        )
    }
    
    
}
// Preview
#Preview {
    NSCanvasView {
        Text("Center of Canvas")
            .position(x: 1500, y: 1500) // Placed in the middle
    }
}

