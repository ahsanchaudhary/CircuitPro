import SwiftUI
import AppKit


struct NSScrollViewWrapper<Content: View>: NSViewRepresentable {
    @Binding var zoomLevel: CGFloat
    let content: () -> Content

    init(zoomLevel: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self._zoomLevel = zoomLevel
        self.content = content
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(zoomLevel: $zoomLevel)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = LiveZoomScrollView()
        scrollView.allowsMagnification = true
        scrollView.minMagnification = 0.5
        scrollView.maxMagnification = 3.0
        scrollView.magnification = zoomLevel

        let hostingView = NSHostingView(rootView: content())
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        let documentView = NSView()
        documentView.addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: documentView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: documentView.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: documentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: documentView.bottomAnchor)
        ])

        documentView.frame = CGRect(x: 0, y: 0, width: 3000, height: 3000)
        scrollView.documentView = documentView

        // 👇 Real-time magnification update
        scrollView.onMagnificationChanged = { newZoom in

            DispatchQueue.main.async {
                context.coordinator.zoomLevel = newZoom
            }
        }

        context.coordinator.scrollView = scrollView
        return scrollView
    }


    func updateNSView(_ nsView: NSScrollView, context: Context) {
        // Sync SwiftUI → NSScrollView
        if abs(nsView.magnification - zoomLevel) > 0.01 {
            nsView.magnification = zoomLevel
        }
    }

    class Coordinator: NSObject {
        @Binding var zoomLevel: CGFloat
        weak var scrollView: NSScrollView?

        init(zoomLevel: Binding<CGFloat>) {
            self._zoomLevel = zoomLevel
        }

        @objc func magnificationDidChange(_ notification: Notification) {
            guard let scrollView = notification.object as? NSScrollView else { return }
            DispatchQueue.main.async {
                self.zoomLevel = scrollView.magnification
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}


class LiveZoomScrollView: NSScrollView {
    var onMagnificationChanged: ((CGFloat) -> Void)?

    override func magnify(with event: NSEvent) {
        super.magnify(with: event)
        onMagnificationChanged?(self.magnification)
    }
}
