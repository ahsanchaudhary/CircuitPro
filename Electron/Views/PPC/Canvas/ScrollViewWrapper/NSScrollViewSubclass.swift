//
//  NSScrollViewSubclass.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/9/25.
//


//  NSScrollViewSubclass.swift

import AppKit
import SwiftUI
import Combine

@available(macOS 10.15, *)
final class NSScrollViewSubclass: NSScrollView, NSGestureRecognizerDelegate {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        NotificationCenter.default.publisher(for: NSScrollView.willStartLiveMagnifyNotification, object: self)
            .sink { [weak self] _ in
                self?.isLiveMagnify = true
            }
            .store(in: &notificaitonsCancellables)

        NotificationCenter.default.publisher(for: NSScrollView.didEndLiveMagnifyNotification, object: self)
            .sink { [weak self] _ in
                self?.isLiveMagnify = false
            }
            .store(in: &notificaitonsCancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var isLiveMagnify: Bool = false
    var isAutoscrollEnabled: Bool = true

    // MARK: - Click Gesture

    typealias ClickGestureAction = (_ location: CGPoint) -> Void

    func onClickGesture(count: Int = 1, perform action: ClickGestureAction?) {
        if let action = action {
            setupClickGesture(count: count, perform: action)
        } else {
            resetClickGesture()
        }
    }

    @objc func handleClick(gestureRecognizer: NSClickGestureRecognizer) {
        guard let action = clickGestureAction else { return }
        let location = gestureRecognizer.location(in: documentView)
        action(location)
    }

    private func setupClickGesture(count: Int, perform action: @escaping ClickGestureAction) {
        let selector = #selector(handleClick(gestureRecognizer:))
        let gestureRecognizer = NSClickGestureRecognizer(target: self, action: selector)
        gestureRecognizer.numberOfClicksRequired = count
        gestureRecognizer.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(gestureRecognizer)

        clickGestureRecognizer = gestureRecognizer
        clickGestureAction = action
    }

    private func resetClickGesture() {
        if let recognizer = clickGestureRecognizer {
            removeGestureRecognizer(recognizer)
        }
        clickGestureRecognizer = nil
        clickGestureAction = nil
    }

    private weak var clickGestureRecognizer: NSClickGestureRecognizer?
    private var clickGestureAction: ClickGestureAction?

    // MARK: - Pan Gesture

    typealias PanGestureAction = (_ phase: ContinuousGesturePhase, _ location: CGPoint, _ translation: CGPoint) -> Bool

    func onPanGesture(perform action: PanGestureAction?) {
        if let action = action {
            setupPanGesture(perform: action)
        } else {
            resetPanGesture()
        }
    }

    @objc func handlePan(gestureRecognizer: NSAutoscrollPanGestureRecognizer, event: Any) {
        guard let panAction = panGestureAction,
              let documentView = documentView,
              let phase = ContinuousGesturePhase(gestureRecognizer.state) else {
            return
        }

        if isAutoscrollEnabled {
            let visibleRect = documentVisibleRect
            if gestureRecognizer.isContentSelected,
               phase == .changed,
               let event = gestureRecognizer.mouseDraggedEvent {
                documentView.autoscroll(with: event)
                gestureRecognizer.translationOffset += documentVisibleRect.origin - visibleRect.origin
            }
        }

        let location = gestureRecognizer.location(in: documentView)
        let translation = gestureRecognizer.translation(in: documentView)

        gestureRecognizer.isContentSelected = panAction(phase, location, translation)
    }

    private func setupPanGesture(perform action: @escaping PanGestureAction) {
        let selector = #selector(handlePan(gestureRecognizer:event:))
        let gestureRecognizer = NSAutoscrollPanGestureRecognizer(target: self, action: selector)
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        contentView.addGestureRecognizer(gestureRecognizer)

        panGestureRecognizer = gestureRecognizer
        panGestureAction = action
    }

    private func resetPanGesture() {
        if let recognizer = panGestureRecognizer {
            removeGestureRecognizer(recognizer)
        }
        panGestureRecognizer = nil
        panGestureAction = nil
    }

    private weak var panGestureRecognizer: NSPanGestureRecognizer?
    private var panGestureAction: PanGestureAction?

    // MARK: - NSGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
        guard gestureRecognizer == panGestureRecognizer,
              let action = panGestureAction,
              let view = documentView else {
            return true
        }

        let location = gestureRecognizer.location(in: view)
        let translation = (gestureRecognizer as! NSPanGestureRecognizer).translation(in: view)

        return action(.possible, location, translation)
    }

    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        return gestureRecognizer == panGestureRecognizer &&
               otherGestureRecognizer == clickGestureRecognizer
    }

    // MARK: - Internal Helpers

    private var notificaitonsCancellables: Set<AnyCancellable> = []
}

@available(macOS 10.15, *)
final class NSClipViewSubclass: NSClipView {}

@available(macOS 10.15, *)
final class NSHostingViewSubclass<Content: View>: NSHostingView<Content> {}

//EOF
