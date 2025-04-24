import SwiftUI

struct ZoomControlView: View {
    
    @Environment(\.scrollViewManager) var scrollViewManager
    
    enum ZoomStep: CGFloat, CaseIterable, Comparable {
        case x0_5 = 0.5
        case x0_75 = 0.75
        case x1 = 1.0
        case x1_25 = 1.25
        case x1_5 = 1.5
        case x2 = 2.0
        case x3 = 3.0
        case x4 = 4.0
        case x5 = 5.0
        case x10 = 10.0
        case x50 = 50.0

        static func < (lhs: ZoomStep, rhs: ZoomStep) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        var percentageString: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            let percent = rawValue * 100
            return "\(formatter.string(from: NSNumber(value: Double(percent))) ?? "\(Int(percent))")%"
        }
    }


    var currentZoom: CGFloat {
        scrollViewManager.currentMagnification
    }

    var clampedZoomText: String {
        let clamped = max(ZoomStep.allCases.first!.rawValue, min(currentZoom, ZoomStep.allCases.last!.rawValue))
        return "\(Int(clamped * 100))%"
    }

    private func zoomOut() {
        let current = currentZoom
        if let currentIndex = ZoomStep.allCases.firstIndex(where: { $0.rawValue >= current }), currentIndex > 0 {
            scrollViewManager.proxy?.magnification = ZoomStep.allCases[currentIndex - 1].rawValue
        }
    }

    private func zoomIn() {
        let current = currentZoom
        if let currentIndex = ZoomStep.allCases.firstIndex(where: { $0.rawValue > current }), currentIndex < ZoomStep.allCases.count {
            scrollViewManager.proxy?.magnification = ZoomStep.allCases[currentIndex].rawValue
        }
    }

    var body: some View {
        HStack {
            zoomButton(action: zoomOut, systemImage: AppIcons.minus)

            Divider().frame(height: 10)

            Menu {
                ForEach(ZoomStep.allCases, id: \.self) { step in
                    Button {
                        scrollViewManager.proxy?.magnification = step.rawValue
                    } label: {
                        Text(step.percentageString)
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
