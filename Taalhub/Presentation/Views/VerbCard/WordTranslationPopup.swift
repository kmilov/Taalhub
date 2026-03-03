import SwiftUI

struct WordTranslationPopup: View {
    let word: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(word)
                .font(.custom("Georgia-BoldItalic", size: 22))
                .foregroundColor(Color("Gold"))
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider().background(Color("Divider"))

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    Text("EN")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(Color("Muted"))
                        .frame(width: 24, alignment: .leading)
                    Text("(translation unavailable)")
                        .font(.custom("Georgia-Italic", size: 15))
                        .foregroundColor(Color("TextPrimary"))
                }
                HStack(alignment: .top, spacing: 10) {
                    Text("ES")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(Color("Muted"))
                        .frame(width: 24, alignment: .leading)
                    Text("(traducción no disponible)")
                        .font(.custom("Georgia-Italic", size: 15))
                        .foregroundColor(Color("TextPrimary"))
                }
            }

            Button("Save word") {
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color("Gold"))
            .foregroundColor(.black)
            .cornerRadius(10)
            .font(.system(size: 13, weight: .semibold, design: .monospaced))
        }
        .padding(20)
        .frame(minWidth: 240)
        .background(Color.appSurface)
    }
}

#Preview {
    WordTranslationPopup(word: "schrijft")
        .background(Color.appBackground)
}
