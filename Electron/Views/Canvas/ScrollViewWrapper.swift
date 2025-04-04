//
//  ScrollViewWrapper.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/4/25.
//


import SwiftUI
import AppKit

struct ScrollViewWrapper<Content: View>: NSViewRepresentable {
    // The SwiftUI content to be displayed inside the scroll view
    var content: Content
    
    // A binding to control and observe the magnification (zoom) level
    @Binding var magnification: CGFloat
    
    // A flag to enable or disable zooming
    var allowsMagnification: Bool

    // Create a coordinator to manage observation of the scroll view's magnification
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Set up the NSScrollView when it's first created
    func makeNSView(context: Context) -> NSScrollView {
        // Create the scroll view
        let scrollView = NSScrollView()
        
        // Create an NSHostingView to host the SwiftUI content
        let hostingView = NSHostingView(rootView: content)
        
        // Set the hosting view as the document view of the scroll view
        scrollView.documentView = hostingView
        
        // Configure zooming properties
        scrollView.allowsMagnification = allowsMagnification
        scrollView.magnification = magnification
        
        // Start observing magnification changes via the coordinator
        context.coordinator.observeMagnification(of: scrollView)
        
        return scrollView
    }

    // Update the NSScrollView when SwiftUI state changes
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        // Update the content in the hosting view if it has changed
        if let hostingView = nsView.documentView as? NSHostingView<Content> {
            hostingView.rootView = content
        }
        
        // Update zooming properties
        nsView.allowsMagnification = allowsMagnification
        
        // Only update magnification if it differs, to avoid unnecessary updates
        if nsView.magnification != magnification {
            nsView.magnification = magnification
        }
    }

    // Coordinator class to handle magnification observation
    class Coordinator: NSObject {
        var parent: ScrollViewWrapper
        var observation: NSKeyValueObservation?

        init(_ parent: ScrollViewWrapper) {
            self.parent = parent
        }

        // Observe changes to the scroll view's magnification property
        func observeMagnification(of scrollView: NSScrollView) {
            observation = scrollView.observe(\.magnification, options: [.new]) { [weak self] _, change in
                if let newValue = change.newValue {
                    // Update the binding when the magnification changes (e.g., via gestures)
                    self?.parent.magnification = newValue
                }
            }
        }
    }
}