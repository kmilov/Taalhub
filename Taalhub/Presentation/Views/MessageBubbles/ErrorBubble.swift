import SwiftUI

struct ErrorBubble: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.red.opacity(0.7))
                .frame(width: 28, height: 28)
                .overlay(Image(systemName: "exclamationmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white))

            Text(message)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(.red)
                .padding(14)
                .background(Color.red.opacity(0.1))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.red.opacity(0.3), lineWidth: 1))

            Spacer(minLength: 40)
        }
    }
}
