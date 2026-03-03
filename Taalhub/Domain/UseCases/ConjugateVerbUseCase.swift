struct ConjugateVerbUseCase {
    private let conjugationRepository: any VerbConjugationRepository
    private let savedRepository: any SavedVerbRepository

    init(conjugationRepository: any VerbConjugationRepository,
         savedRepository: any SavedVerbRepository) {
        self.conjugationRepository = conjugationRepository
        self.savedRepository = savedRepository
    }

    func execute(infinitive: String) async throws -> VerbCard {
        let card = try await conjugationRepository.fetchConjugation(for: infinitive)
        savedRepository.save(card)
        return card
    }
}
