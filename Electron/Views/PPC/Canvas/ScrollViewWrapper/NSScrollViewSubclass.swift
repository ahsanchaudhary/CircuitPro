
//  NSScrollViewSubclass.swift

import AppKit
import SwiftUI

final class NSScrollViewSubclass: NSScrollView {
    
    private var liveMagnifyTask: Task<Void, Never>?
    private var endMagnifyTask: Task<Void, Never>?

    private(set) var isLiveMagnify: Bool = false
    var isAutoscrollEnabled: Bool = true

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        liveMagnifyTask = Task { [weak self] in
            guard let self = self else { return }
            for await _ in NotificationCenter.default.notifications(
                named: NSScrollView.willStartLiveMagnifyNotification,
                object: self
            ) {
                self.isLiveMagnify = true
            }
        }
        
        endMagnifyTask = Task { [weak self] in
            guard let self = self else { return }
            for await _ in NotificationCenter.default.notifications(
                named: NSScrollView.didEndLiveMagnifyNotification,
                object: self
            ) {
                self.isLiveMagnify = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        liveMagnifyTask?.cancel()
        endMagnifyTask?.cancel()
    }
}

final class NSClipViewSubclass: NSClipView {}


final class NSHostingViewSubclass<Content: View>: NSHostingView<Content> {}

//EOF
