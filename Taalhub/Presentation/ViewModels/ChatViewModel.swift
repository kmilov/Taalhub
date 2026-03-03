import Foundation
import Combine
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false

    private let conjugateVerbUseCase: ConjugateVerbUseCase
    private let savedVerbRepository: any SavedVerbRepository

    let quickVerbs = ["werken", "gaan", "schrijven", "eten", "rijden", "lopen", "zien", "maken", "komen", "lezen"]

    init(conjugationRepository: any VerbConjugationRepository,
         savedVerbRepository: any SavedVerbRepository) {
        self.conjugateVerbUseCase = ConjugateVerbUseCase(
            conjugationRepository: conjugationRepository,
            savedRepository: savedVerbRepository
        )
        self.savedVerbRepository = savedVerbRepository
        self.messages = savedVerbRepository.fetchAll().map { ChatMessage(type: .verbCard($0)) }
    }

    func sendVerb() {
        let verb = inputText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !verb.isEmpty, !isLoading else { return }

        inputText = ""
        isLoading = true

        messages.append(ChatMessage(type: .userInput(verb)))

        let loadingMsg = ChatMessage(type: .loading(verb))
        messages.append(loadingMsg)

        Task {
            do {
                let card = try await conjugateVerbUseCase.execute(infinitive: verb)
                messages.removeAll { $0.id == loadingMsg.id }
                messages.append(ChatMessage(type: .verbCard(card)))
            } catch {
                messages.removeAll { $0.id == loadingMsg.id }
                messages.append(ChatMessage(type: .error(error.localizedDescription)))
            }
            isLoading = false
        }
    }

    func sendQuickVerb(_ verb: String) {
        inputText = verb
        sendVerb()
    }

    func deleteAllSavedVerbs() {
        savedVerbRepository.deleteAll()
        messages.removeAll {
            if case .verbCard = $0.type { return true }
            return false
        }
    }
}

extension ChatViewModel {
    convenience init() {
        let savedRepo = CoreDataVerbRepository()
        self.init(
            conjugationRepository: AnthropicVerbRepository(),
            savedVerbRepository: savedRepo
        )
    }
}
