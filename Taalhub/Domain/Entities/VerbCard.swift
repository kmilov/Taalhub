import Foundation

struct VerbCard: Identifiable {
    let id: UUID
    let infinitive: String
    let vtt: String          // Voltooid deelwoord (past participle)
    let ovt: String          // Onvoltooid verleden tijd (simple past)
    let isIrregular: Bool
    let sentences: [String]?
    let auxVerb: String      // "hebben" or "zijn"
    let english: String
    let spanish: String

    init(id: UUID = UUID(), infinitive: String, vtt: String, ovt: String,
         isIrregular: Bool, sentences: [String], auxVerb: String,
         english: String? = nil, spanish: String? = nil) {
        self.id = id
        self.infinitive = infinitive
        self.vtt = vtt
        self.ovt = ovt
        self.isIrregular = isIrregular
        self.sentences = sentences
        self.auxVerb = auxVerb
        self.english = english ?? "-"
        self.spanish = spanish ?? "-"
    }
}
