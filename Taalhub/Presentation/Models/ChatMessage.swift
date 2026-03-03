import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let type: MessageType
    let timestamp: Date

    enum MessageType {
        case userInput(String)
        case verbCard(VerbCard)
        case loading(String)
        case error(String)
    }

    init(type: MessageType) {
        self.id = UUID()
        self.type = type
        self.timestamp = Date()
    }
}
