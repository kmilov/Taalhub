import SwiftUI

struct WelcomeView: View {
    let quickVerbs: [String]
    let onTap: (String) -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("🇳🇱")
                    .font(.system(size: 48))
                Text("Type any Dutch infinitive")
                    .font(.custom("Georgia-Italic", size: 18))
                    .foregroundColor(Color.appText)
                Text("and get the conjugations instantly")
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(Color.appMuted)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Try one of these:")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(Color.appMuted)
                    .tracking(2)
                    .textCase(.uppercase)
                    .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Spacer().frame(width: 12)
                        ForEach(quickVerbs, id: \.self) { verb in
                            Button(action: { onTap(verb) }) {
                                Text(verb)
                                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                                    .foregroundColor(Color.appGold)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.appGold.opacity(0.1))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.appGold.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        Spacer().frame(width: 12)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
