import SwiftUI

struct ZoomControlView: View {
    
//    @Environment(ScrollViewManager.self) private var scrollViewManager
    
    var currentZoom: CGFloat {
        1.0
    }

    var clampedZoomText: String {
        let clamped = max(ZoomStep.allCases.first!.rawValue, min(currentZoom, ZoomStep.allCases.last!.rawValue))
        return "\(Int(clamped * 100))%"
    }

    private func zoomOut() {
        let current = currentZoom
        if let currentIndex = ZoomStep.allCases.firstIndex(where: { $0.rawValue >= current }), currentIndex > 0 {
//            scrollViewManager.proxy?.magnification = ZoomStep.allCases[currentIndex - 1].rawValue
        }
    }

    private func zoomIn() {
        let current = currentZoom
        if let currentIndex = ZoomStep.allCases.firstIndex(where: { $0.rawValue > current }), currentIndex < ZoomStep.allCases.count {
//            scrollViewManager.proxy?.magnification = ZoomStep.allCases[currentIndex].rawValue
        }
    }

    var body: some View {
        HStack {
            zoomButton(action: zoomOut, systemImage: AppIcons.minus)

            Divider().frame(height: 10)

            Menu {
                ForEach(ZoomStep.allCases) { step in
                    Button {
//                        scrollViewManager.proxy?.magnification = step.rawValue
                    } label: {
                        Text(step.label)
                    }
                }
            } label: {
                HStack {
                    Text(clampedZoomText)
                    Image(systemName: AppIcons.chevronDown)
                        .imageScale(.small)
                }
            }

            Divider().frame(height: 10)

            zoomButton(action: zoomIn, systemImage: AppIcons.plus)
        }
        .buttonStyle(.plain)
        .font(.callout)
        .fontWeight(.semibold)
        .directionalPadding(vertical: 7.5, horizontal: 10)
        .background(.ultraThinMaterial)
        .clipAndStroke(with: .capsule, strokeColor: .gray.opacity(0.3), lineWidth: 1)
    }

    private func zoomButton(action: @escaping () -> Void, systemImage: String) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .frame(width: 15, height: 15)
                .contentShape(Rectangle())
        }
    }
}
