import SwiftUI

struct CardFrontView: View {
    let card: VerbCard

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top badge row
            HStack {
                Label(card.isIrregular ? "Onregelmatig" : "Regelmatig",
                      systemImage: card.isIrregular ? "bolt.fill" : "checkmark.circle.fill")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(card.isIrregular ? Color.appIrregular : Color.appRegular)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background((card.isIrregular ? Color.appIrregular : Color.appRegular).opacity(0.12))
                    .cornerRadius(10)

                Spacer()

                Text(card.auxVerb)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.appMuted)
                    .tracking(1)
                    .textCase(.uppercase)
            }
            .padding(.horizontal, 18)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Divider().background(Color.appDivider)

            // Infinitive
            VStack(alignment: .leading, spacing: 4) {
                Label("INFINITIEF", systemImage: "textformat")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.appMuted)
                    .tracking(2)
                Text(card.infinitive)
                    .font(.custom("Georgia-BoldItalic", size: 32))
                    .foregroundColor(Color.appGold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)

            // Translation
            HStack(spacing: 4) {
                Text(card.english)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.appMuted)
                Text("·")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Color.appMuted)
                Text(card.spanish)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.appMuted)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 14)

            Divider().background(Color.appDivider)

            // OVT + VTT row
            HStack(spacing: 0) {
                ConjugationCell(label: "OVT", sublabel: "Verleden Tijd", value: card.ovt)
                Rectangle().fill(Color.appDivider).frame(width: 1)
                ConjugationCell(label: "VTT", sublabel: "Deelwoord", value: "\(card.auxVerb) \(card.vtt)")
            }
            .frame(height: 90)

            Divider().background(Color.appDivider)

            // Tap hint
            HStack {
                Spacer()
                Label("Tik voor voorbeeldzinnen", systemImage: "hand.tap")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color.appMuted)
                Spacer()
            }
            .padding(.vertical, 10)
        }
        .background(Color.appSurface)
        .cornerRadius(18)
        .cornerRadius(4, corners: .bottomLeft)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.appDivider, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

struct ConjugationCell: View {
    let label: String
    let sublabel: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            VStack(spacing: 1) {
                Text(label)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.appGold)
                    .tracking(3)
                Text(sublabel)
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundColor(Color.appMuted)
            }
            Text(value)
                .font(.custom("Georgia-Italic", size: 16))
                .foregroundColor(Color.appText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
    }
}


#Preview {
    let front = VerbCard(
        infinitive: "Lopen",
        vtt: "hebben gelopen",
        ovt: "liep",
        isIrregular: true,
        sentences: ["Ik heb naar de kantoor gelopen", "learn to use liep"],
        auxVerb: "",
        english: "To walk",
        spanish: "Caminar"
    )
    
    CardFrontView(card: front)
        .padding()
}
