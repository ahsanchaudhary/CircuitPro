import SwiftUI
import AdvancedScrollView // Make sure to import

// Type aliases matching AdvancedScrollView for convenience
typealias TapContentAction = (_ location: CGPoint, _ proxy: AdvancedScrollViewProxy) -> Void
typealias DragContentAction = (_ phase: ContinuousGesturePhase, _ location: CGPoint, _ translation: CGSize, _ proxy: AdvancedScrollViewProxy) -> Bool

struct NSCanvasView<Content: View>: View {

    
    // Content closure provided by the user
    @ViewBuilder var content: () -> Content

    // --- Configuration for AdvancedScrollView (can be customized via init/modifiers) ---
    var magnificationRange: ClosedRange<CGFloat> = 0.5...2.0
    var initialMagnification: CGFloat = 1.0
    var showsScrollIndicators: Bool = true
    var isMagnificationRelative: Bool = false
    var canvasSize: CGSize = CGSize(width: 3000, height: 3000)

    @State private var hasScrolledToCenter = false
    // --- Stored Gesture Actions ---
    private var onTapAction: TapContentAction? = nil
    private var tapGestureCount: Int = 1
    private var onDragAction: DragContentAction? = nil

    // --- Internal Initializer (Used by modifiers) ---
    // Needs to copy all configurable properties
    private init(
        content: @escaping () -> Content,
        magnificationRange: ClosedRange<CGFloat>,
        initialMagnification: CGFloat,
        showsScrollIndicators: Bool,
        isMagnificationRelative: Bool,
        canvasSize: CGSize,
        onTapAction: TapContentAction?,
        tapGestureCount: Int,
        onDragAction: DragContentAction?
    ) {
        self.content = content
        self.magnificationRange = magnificationRange
        self.initialMagnification = initialMagnification
        self.showsScrollIndicators = showsScrollIndicators
        self.isMagnificationRelative = isMagnificationRelative
        self.canvasSize = canvasSize
        self.onTapAction = onTapAction
        self.tapGestureCount = tapGestureCount
        self.onDragAction = onDragAction
    }

    // --- Public Initializer ---
    init(
        canvasSize: CGSize = CGSize(width: 3000, height: 3000),
        magnificationRange: ClosedRange<CGFloat> = 0.5...2.0,
        initialMagnification: CGFloat = 1.0,
        showsScrollIndicators: Bool = true,
        isMagnificationRelative: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.canvasSize = canvasSize
        self.magnificationRange = magnificationRange
        self.initialMagnification = initialMagnification
        self.showsScrollIndicators = showsScrollIndicators
        self.isMagnificationRelative = isMagnificationRelative
        // Initialize gesture actions to nil
        self.onTapAction = nil
        self.tapGestureCount = 1
        self.onDragAction = nil
    }


    var body: some View {
        // Create the AdvancedScrollView instance
        var scrollView = AdvancedScrollView(
            magnification: Magnification(
                range: magnificationRange,
                initialValue: initialMagnification,
                isRelative: isMagnificationRelative
            ),
            isScrollIndicatorVisible: showsScrollIndicators
        ) { proxy in
            
          
            ZStack {
                CanvasContentView {
                    content()
                }
               
            }
            .frame(width: canvasSize.width, height: canvasSize.height)
            .padding(10)
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
            .overlay(alignment: .bottom) {
                HStack {
                    
                    Spacer()
                    CanvasControlView()
                }
                .padding()
            }
        
    }

    // --- Custom Modifiers for CanvasView ---

    /// Sets the action to perform when the content area is tapped.
    func onTapContentGesture(count: Int = 1, perform action: @escaping TapContentAction) -> NSCanvasView {
        // Create a new CanvasView, copying existing state and adding the tap action
        NSCanvasView(
            content: self.content,
            magnificationRange: self.magnificationRange,
            initialMagnification: self.initialMagnification,
            showsScrollIndicators: self.showsScrollIndicators,
            isMagnificationRelative: self.isMagnificationRelative,
            canvasSize: self.canvasSize,
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
            magnificationRange: self.magnificationRange,
            initialMagnification: self.initialMagnification,
            showsScrollIndicators: self.showsScrollIndicators,
            isMagnificationRelative: self.isMagnificationRelative,
            canvasSize: self.canvasSize,
            onTapAction: self.onTapAction, // Keep existing tap action
            tapGestureCount: self.tapGestureCount, // Keep existing tap count
            onDragAction: action // Set the drag action
         )
    }

    // --- You could add more modifiers to configure other properties ---
    func canvasMagnification(range: ClosedRange<CGFloat>, initial: CGFloat = 1.0, relative: Bool = false) -> NSCanvasView {
        var newView = self
        newView.magnificationRange = range
        newView.initialMagnification = initial
        newView.isMagnificationRelative = relative
        return newView
    }

    func canvasShowsScrollIndicators(_ visible: Bool) -> NSCanvasView {
         var newView = self
         newView.showsScrollIndicators = visible
         return newView
    }
}
// Preview
#Preview {
    NSCanvasView {
        Text("Center of Canvas")
            .position(x: 1500, y: 1500) // Placed in the middle
    }
}

