import SwiftUI

struct ZoomControlView: View {

    @Environment(\.scrollViewManager) var scrollViewManager

    let zoomSteps: [CGFloat] = [0.5, 0.75, 1, 1.25, 1.5, 2.0]

    var currentZoom: CGFloat {
        scrollViewManager.currentMagnification
    }

    var clampedZoomText: String {
        let clamped = max(0.5, min(currentZoom, 2.0))
        return "\(Int(clamped * 100))%"
    }
    
    private func zoomOut() {
           if let currentIndex = zoomSteps.firstIndex(where: { $0 >= currentZoom }), currentIndex > 0 {
               scrollViewManager.proxy?.magnification = zoomSteps[currentIndex - 1]
           }
       }

       /// Moves one step up if possible
       private func zoomIn() {
           if let currentIndex = zoomSteps.firstIndex(where: { $0 > currentZoom }), currentIndex < zoomSteps.count {
               scrollViewManager.proxy?.magnification = zoomSteps[currentIndex]
           }
       }

    var body: some View {
        HStack {
            zoomButton(action: zoomOut, systemImage: AppIcons.minus)
        

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
