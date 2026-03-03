protocol SavedVerbRepository {
    func fetchAll() -> [VerbCard]
    func save(_ verbCard: VerbCard)
    func deleteAll()
}
