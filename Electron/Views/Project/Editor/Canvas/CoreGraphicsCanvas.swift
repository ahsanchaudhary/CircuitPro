import SwiftUI

struct CoreGraphicsCanvas: NSViewRepresentable {

    @Bindable var manager: CanvasManager
    @Binding var elements: [CanvasElement]
    @Binding var selectedIDs: Set<UUID>
    @Binding var selectedTool: AnyCanvasTool

    final class Coordinator {
        let canvas: CanvasView
        let background: BackgroundView

        init() {
            self.canvas = CanvasView()
            self.background = BackgroundView()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> NSScrollView {
        let boardSize: CGFloat = 5000
        let boardRect = NSRect(x: 0, y: 0, width: boardSize, height: boardSize)

        let background = context.coordinator.background
        let canvas = context.coordinator.canvas

        background.frame = boardRect
        canvas.frame = boardRect

        background.currentStyle = manager.backgroundStyle

        canvas.elements = elements
        canvas.selectedIDs = selectedIDs
        canvas.selectedTool = selectedTool
        canvas.magnification = manager.magnification
        canvas.onUpdate = { self.elements = $0 }
        canvas.onSelectionChange = { self.selectedIDs = $0 }

        let container = NSView(frame: boardRect)
        container.wantsLayer = true

        background.autoresizingMask = [.width, .height]
        canvas.autoresizingMask = [.width, .height]

        container.addSubview(background)
        container.addSubview(canvas)

        let scrollView = NSScrollView()
        scrollView.documentView = container
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = true
        scrollView.allowsMagnification = true
        scrollView.minMagnification = 0.5
        scrollView.maxMagnification = 10.0
        scrollView.magnification = manager.magnification

        centerScrollView(scrollView, container: container)

        scrollView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: scrollView.contentView, queue: .main) { _ in
            self.manager.magnification = scrollView.magnification
        }

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        let canvas = context.coordinator.canvas
        let background = context.coordinator.background

        canvas.elements = elements
        canvas.selectedIDs = selectedIDs
        canvas.selectedTool = selectedTool
        canvas.magnification = manager.magnification

        if scrollView.magnification != manager.magnification {
            scrollView.magnification = manager.magnification
        }

        if background.currentStyle != manager.backgroundStyle {
            background.currentStyle = manager.backgroundStyle
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
