import SwiftUI

struct UserBubble: View {
    let text: String

    var body: some View {
        HStack {
            Spacer(minLength: 60)
            Text(text)
                .font(.custom("Georgia-Italic", size: 17))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.appGold)
                .cornerRadius(18)
                .cornerRadius(4, corners: .bottomRight)
        }
    }
}
