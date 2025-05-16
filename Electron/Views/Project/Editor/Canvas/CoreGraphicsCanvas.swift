import SwiftUI

struct CoreGraphicsCanvas: NSViewRepresentable {

    @Binding var elements: [CanvasElement]
    @Binding var selectedIDs: Set<UUID>
    @Binding var canvasBackgroundStyle: CanvasBackgroundStyle
    @Binding var selectedTool: AnyCanvasTool

    // MARK: – Coordinator
    final class Coordinator {
        let canvas     : CanvasView
        let background : BackgroundView
        init() {
            self.canvas     = CanvasView()
            self.background = BackgroundView()
        }
    }
    func makeCoordinator() -> Coordinator { Coordinator() }

    // MARK: – makeNSView
    func makeNSView(context: Context) -> NSScrollView {

        // 1. Decide the board size once
        let boardSize: CGFloat = 5_000
        let boardRect = NSRect(x: 0, y: 0, width: boardSize, height: boardSize)

        // 2. ***Use the coordinator’s views – DO NOT allocate new ones***
        let background = context.coordinator.background
        let canvas     = context.coordinator.canvas

        background.frame = boardRect
        canvas.frame     = boardRect

        //  … your existing property setup …
        background.currentStyle = canvasBackgroundStyle

        canvas.elements          = elements
        canvas.selectedIDs       = selectedIDs
        canvas.onUpdate          = { self.elements = $0 }
        canvas.onSelectionChange = { self.selectedIDs = $0 }

        // 3. Put them in a container
        let container = NSView(frame: boardRect)
        container.wantsLayer = true

        background.autoresizingMask = [.width, .height]
        canvas.autoresizingMask     = [.width, .height]

        container.addSubview(background)
        container.addSubview(canvas)

        // 4. Scroll-view wrapper (unchanged)
        let scrollView = NSScrollView()
        scrollView.documentView         = container
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller   = true
        scrollView.allowsMagnification   = true
        scrollView.minMagnification      = 0.5
        scrollView.maxMagnification      = 10.0
        scrollView.magnification         = 2.5

        centerScrollView(scrollView, container: container)
        return scrollView
    }


    // MARK: – updateNSView
    func updateNSView(_ scroll: NSScrollView, context: Context) {
        let canvas     = context.coordinator.canvas
        let background = context.coordinator.background

        canvas.elements      = elements
        canvas.selectedIDs   = selectedIDs
        canvas.magnification = scroll.magnification
        canvas.selectedTool = selectedTool

        if background.currentStyle != canvasBackgroundStyle {
            background.currentStyle = canvasBackgroundStyle
        }
    }
    
    private func centerScrollView(_ scrollView: NSScrollView, container: NSView) {
        DispatchQueue.main.async {
            let clipSize = scrollView.contentView.bounds.size
            let docSize = container.frame.size
            let centeredOrigin = NSPoint(
                x: (docSize.width - clipSize.width) / 2,
                y: (docSize.height - clipSize.height) / 2
            )
            scrollView.contentView.scroll(to: centeredOrigin)
            scrollView.reflectScrolledClipView(scrollView.contentView)
        }
    }
}
