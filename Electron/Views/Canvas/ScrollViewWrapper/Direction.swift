////
////  Direction.swift
////  Electron
////
////  Created by Giorgi Tchelidze on 4/4/25.
////
//
//
//import CoreGraphics
//
//// Copied/Adapted from ShapeEdit (Shared/Auxiliary/DragInfo.swift)
//enum Direction: CaseIterable {
//    case top, topLeft, left, bottomLeft, bottom, bottomRight, right, topRight
//    // Add cases if needed for resizing, otherwise just moving is fine for now
//}
//
//struct DragInfo {
//    var translation: CGSize
//    var direction: Direction? // nil for moving the whole object
//
//    // Helper to calculate the new origin based on the original point and translation
//    func translatedPoint(_ point: CGPoint) -> CGPoint {
//        // For simple move (direction is nil)
//        guard direction == nil else {
//            // Implement resize handle logic here if needed later
//            print("Warning: Resize direction handling not fully implemented in this example")
//            return point // Return original for now if direction is set
//        }
//        // Just apply the total translation
//        return CGPoint(x: point.x + translation.width, y: point.y + translation.height)
//    }
//
//    // Add translatedSize if implementing resizing later
//    // func translatedSize(_ size: CGSize) -> CGSize { ... }
//
//    // Helper to get the translated frame for display *during* drag
//    func translatedFrame(origin: CGPoint, size: CGSize) -> CGRect {
//         CGRect(origin: translatedPoint(origin), size: size)
//        // Use translatedSize if implementing resizing:
//        // CGRect(origin: translatedPoint(origin), size: translatedSize(size))
//    }
//}
