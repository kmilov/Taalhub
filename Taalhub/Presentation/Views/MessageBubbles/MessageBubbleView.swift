import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage

    var body: some View {
        switch message.type {
        case .userInput(let text):
            UserBubble(text: text)
        case .verbCard(let card):
            VerbCardBubble(card: card)
        case .loading(let verb):
            LoadingBubble(verb: verb)
        case .error(let msg):
            ErrorBubble(message: msg)
        }
    }
}
