import SwiftUI

struct ZoomControlView: View {

    @Environment(\.scrollViewManager) var scrollViewManager

    let zoomSteps: [CGFloat] = [0.5, 0.75, 1, 1.25, 1.5, 2.0]

    var currentZoom: CGFloat {
        scrollViewManager.proxy?.magnification ?? 1.0
    }

    var clampedZoomText: String {
        let clamped = max(0.5, min(currentZoom, 2.0))
        return "\(Int(clamped * 100))%"
    }

    var body: some View {
        HStack {
            Button {
                if let currentIndex = zoomSteps.firstIndex(where: { $0 >= currentZoom }),
                   currentIndex > 0 {
                    scrollViewManager.proxy?.magnification = zoomSteps[currentIndex - 1]
                }
            } label: {
                Image(systemName: AppIcons.minus)
                    .background(
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 30, height: 30)
                    )
                    .contentShape(Rectangle())
            }
            .onChange(of: currentZoom) { oldValue, newValue in
                print(newValue, oldValue)
            }
           

            Divider()
                .frame(height: 10)

            Menu {
                ForEach(zoomSteps, id: \.self) { step in
                    Button {
                        scrollViewManager.proxy?.magnification = step
                    } label: {
                        Text("\(Int(step * 100))%")
                    }
                }
            } label: {
                HStack {
                    Text(clampedZoomText)
                    Image(systemName: AppIcons.chevronDown)
                        .imageScale(.small)
                }
            }

            Divider()
                .frame(height: 10)

            Button {
                if let currentIndex = zoomSteps.firstIndex(where: { $0 > currentZoom }),
                   currentIndex < zoomSteps.count {
                    scrollViewManager.proxy?.magnification = zoomSteps[currentIndex]
                }
            } label: {
                Image(systemName: AppIcons.plus)
            }
        }
        .buttonStyle(.plain)
        .font(.callout)
        .fontWeight(.semibold)
        .directionalPadding(vertical: 7.5, horizontal: 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}
