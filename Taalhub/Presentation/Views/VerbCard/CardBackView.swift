import SwiftUI

struct CardBackView: View {
    let card: VerbCard

    @ViewBuilder var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(card.infinitive)
                    .font(.custom("Georgia-BoldItalic", size: 18))
                    .foregroundColor(Color("Gold"))
                Spacer()
                Label("Voorbeeldzinnen", systemImage: "text.quote")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(Color("Muted"))
                    .tracking(1)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)

            Divider().background(Color("Divider"))

            let sentences: [String] = card.sentences ?? []

            VStack(alignment: .leading, spacing: 14) {
                ForEach(sentences.indices, id: \.self) { index in
                    let sentence = sentences[index]
                    let displayIndex = index + 1
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(displayIndex)")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color("Gold"))
                            .frame(width: 16)
                            .padding(.top, 4)
                        SelectableSentenceView(sentence: sentence, infinitive: card.infinitive)
                    }
                }
            }
            .padding(18)

            Divider().background(Color("Divider"))

            HStack {
                Spacer()
                Label("Tik om terug te gaan", systemImage: "arrow.turn.up.left")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color("Muted"))
                Spacer()
            }
            .padding(.vertical, 10)
        }
        .background(Color.appSurfaceAlt)
        .cornerRadius(18)
        .cornerRadius(4, corners: .bottomLeft)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color("Gold").opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    CardBackView(card: VerbCard(
        infinitive: "schrijven",
        vtt: "geschreven",
        ovt: "schreef",
        isIrregular: true,
        sentences: [
            "Ik schrijf elke dag in mijn dagboek.",
            "Hij schreef een lange brief aan zijn vriend.",
            "Ze hebben een mooi boek geschreven."
        ],
        auxVerb: "hebben",
        english: "to write",
        spanish: "escribir"
    ))
    .padding()
    .background(Color.appBackground)
}
