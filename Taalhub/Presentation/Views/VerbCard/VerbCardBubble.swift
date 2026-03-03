import SwiftUI

struct VerbCardBubble: View {
    let card: VerbCard
    @State private var isFlipped = false
    @State private var appeared = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Avatar
//            Circle()
//                .fill(Color("Gold"))
//                .frame(width: 28, height: 28)
//                .overlay(Text("NL").font(.system(size: 9, weight: .bold)).foregroundColor(.black))
//                .alignmentGuide(.bottom) { d in d[.bottom] }

            // Card
            ZStack {
                // Back face
                CardBackView(card: card)
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))

                // Front face
                CardFrontView(card: card)
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            }
            .frame(maxWidth: .infinity)
            .onTapGesture {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isFlipped.toggle()
                }
            }
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
                    appeared = true
                }
            }

            Spacer().frame(width: 0)
        }
    }
}

#Preview("VerbCardBubble") {
    // TODO: Replace with your app's real sample data if available
    let sampleCard = VerbCard(
        infinitive: "Lopen",
        vtt: "hebben gelopen",
        ovt: "liep",
        isIrregular: true,
        sentences: ["Ik heb naar de kantoor gelopen", "learn to use liep"],
        auxVerb: ""
    )
    
    
    VerbCardBubble(card: sampleCard)
        .padding()
}

