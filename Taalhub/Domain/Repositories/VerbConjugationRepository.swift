protocol VerbConjugationRepository {
    func fetchConjugation(for infinitive: String) async throws -> VerbCard
}
