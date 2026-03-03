import SwiftUI

struct SavedWordsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "bookmark")
                .font(.system(size: 40))
                .foregroundColor(Color("Muted"))
            Text("Saved Words")
                .font(.custom("Georgia-BoldItalic", size: 22))
                .foregroundColor(Color("Gold"))
            Text("Words you translate will appear here.")
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color("Muted"))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

#Preview {
    SavedWordsView()
}
