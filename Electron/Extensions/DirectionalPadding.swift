import SwiftUI

struct DirectionalPadding: ViewModifier {
    var vertical: CGFloat
    var horizontal: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.vertical, vertical)
            .padding(.horizontal, horizontal)
    }
}
