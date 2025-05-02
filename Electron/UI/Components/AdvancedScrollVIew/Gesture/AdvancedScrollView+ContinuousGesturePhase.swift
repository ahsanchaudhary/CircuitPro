//AdvancedScrollView+ContinuousGesturePhase.swift
import SwiftUI

public enum ContinuousGesturePhase {
    case possible
    case began
    case changed
    case cancelled
    case ended
}

extension ContinuousGesturePhase {

    init?(_ state: NSGestureRecognizer.State) {
        switch state {
        case .possible:
            self = .possible
        case .began:
            self = .began
        case .changed:
            self = .changed
        case .cancelled, .failed:
            self = .cancelled
        case .ended:
            self = .ended
        default:
            return nil
        }
    }
}

//EOF
