import Foundation

struct AnthropicRequest: Codable {
    let model: String
    let max_tokens: Int
    let system: String
    let messages: [AnthropicMessage]
}

struct AnthropicMessage: Codable {
    let role: String
    let content: String
}

struct AnthropicResponse: Codable {
    let content: [ContentBlock]

    struct ContentBlock: Codable {
        let type: String
        let text: String?
    }
}

struct VerbAPIResponse: Codable {
    let infinitive: String
    let vtt: String
    let ovt: String
    let isIrregular: Bool
    let auxVerb: String
    let sentences: [String]
    let english: String?
    let spanish: String?

    enum CodingKeys: String, CodingKey {
        case infinitive, vtt, ovt, auxVerb, sentences
        case isIrregular = "irregular"
        case english, spanish
    }

    func toDomain() -> VerbCard {
        VerbCard(
            infinitive: infinitive,
            vtt: vtt,
            ovt: ovt,
            isIrregular: isIrregular,
            sentences: sentences,
            auxVerb: auxVerb,
            english: english,
            spanish: spanish
        )
    }
}
