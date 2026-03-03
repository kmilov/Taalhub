import SwiftUI

struct LoadingBubble: View {
    let verb: String
    @State private var animating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Circle()
                .fill(Color.appGold.opacity(0.8))
                .frame(width: 28, height: 28)
                .overlay(Text("NL").font(.system(size: 9, weight: .bold)).foregroundColor(.black))

            HStack(spacing: 5) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Color.appGold)
                        .frame(width: 7, height: 7)
                        .offset(y: animating ? -4 : 4)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color.appSurface)
            .cornerRadius(18)
            .cornerRadius(4, corners: .bottomLeft)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.appDivider, lineWidth: 1)
            )

            Spacer(minLength: 60)
        }
        .onAppear { animating = true }
    }
}
