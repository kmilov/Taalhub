import Foundation

class AnthropicVerbRepository: VerbConjugationRepository {

    private let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["AnthropicAPIKey"] as? String
        else { fatalError("Missing AnthropicAPIKey in Secrets.plist") }
        return key
    }()
    private let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!

    var debugEnabled = true

    func fetchConjugation(for infinitive: String) async throws -> VerbCard {
        let systemPrompt = """
        You are a Dutch language expert. Return ONLY valid JSON with no markdown fences, no explanation, nothing else.
        """

        let userPrompt = """
        For the Dutch infinitive "\(infinitive)", return this exact JSON structure:
        {
          "infinitive": "the corrected/canonical Dutch infinitive",
          "vtt": "voltooid deelwoord (past participle), e.g. gewerkt or gelopen",
          "ovt": "onvoltooid verleden tijd singular, e.g. werkte or liep",
          "irregular": true or false,
          "auxVerb": "hebben or zijn",
          "sentences": [
            "A natural Dutch sentence using this verb",
            "Another natural Dutch sentence using a the ovt tense of this verb",
            "Another natural Dutch sentence using a the vvt tense of this verb"
          ],
          "english: "The translation to english of this verb",
          "spanish: "The translation to spanish of this verb",
        }
        Return ONLY the JSON object. No markdown, no explanation.
        """

        let requestBody = AnthropicRequest(
            model: "claude-opus-4-5",
            max_tokens: 600,
            system: systemPrompt,
            messages: [AnthropicMessage(role: "user", content: userPrompt)]
        )

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let bodyData = try encoder.encode(requestBody)
        request.httpBody = bodyData

        debugLog("""

        ╔══════════════════════════════════════════╗
        ║           ANTHROPIC API REQUEST          ║
        ╚══════════════════════════════════════════╝
        🌐 URL:    \(endpoint.absoluteString)
        📡 Method: \(request.httpMethod ?? "POST")

        📋 HEADERS:
        \(formatHeaders(request.allHTTPHeaderFields))

        📦 BODY:
        \(String(data: bodyData, encoding: .utf8) ?? "<unreadable>")
        ──────────────────────────────────────────
        """)

        let startTime = Date()
        let (data, response) = try await URLSession.shared.data(for: request)
        let elapsed = String(format: "%.2f", Date().timeIntervalSince(startTime))

        guard let httpResponse = response as? HTTPURLResponse else {
            debugLog("❌ ERROR: Response is not an HTTP response")
            throw APIError.badResponse(statusCode: 0, body: "Not an HTTP response")
        }

        let rawResponseString = String(data: data, encoding: .utf8) ?? "<unreadable>"

        debugLog("""

        ╔══════════════════════════════════════════╗
        ║           ANTHROPIC API RESPONSE         ║
        ╚══════════════════════════════════════════╝
        ⏱  Duration:   \(elapsed)s
        📶 Status:     \(httpResponse.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))

        📋 RESPONSE HEADERS:
        \(formatHeaders(httpResponse.allHeaderFields as? [String: String]))

        📨 RAW BODY:
        \(rawResponseString)
        ──────────────────────────────────────────
        """)

        guard httpResponse.statusCode == 200 else {
            debugLog("❌ ERROR: Non-200 status code \(httpResponse.statusCode)")
            throw APIError.badResponse(statusCode: httpResponse.statusCode, body: rawResponseString)
        }

        let anthropicResponse: AnthropicResponse
        do {
            anthropicResponse = try JSONDecoder().decode(AnthropicResponse.self, from: data)
        } catch {
            debugLog("❌ ERROR decoding AnthropicResponse: \(error)")
            throw APIError.decodingError(detail: error.localizedDescription)
        }

        guard let textContent = anthropicResponse.content.first(where: { $0.type == "text" })?.text else {
            debugLog("❌ ERROR: No text content block found in response")
            throw APIError.noContent
        }

        let cleaned = textContent
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        debugLog("""

        ╔══════════════════════════════════════════╗
        ║         EXTRACTED VERB JSON              ║
        ╚══════════════════════════════════════════╝
        \(cleaned)
        ──────────────────────────────────────────
        """)

        guard let jsonData = cleaned.data(using: .utf8) else {
            debugLog("❌ ERROR: Could not convert cleaned text to Data")
            throw APIError.parseError
        }

        let verbResponse: VerbAPIResponse
        do {
            verbResponse = try JSONDecoder().decode(VerbAPIResponse.self, from: jsonData)
        } catch {
            debugLog("❌ ERROR decoding VerbAPIResponse: \(error)\nRaw JSON was:\n\(cleaned)")
            throw APIError.decodingError(detail: error.localizedDescription)
        }

        let card = verbResponse.toDomain()

        debugLog("""

        ╔══════════════════════════════════════════╗
        ║             PARSED VERB CARD             ║
        ╚══════════════════════════════════════════╝
        📖 Infinitive : \(card.infinitive)
        🔵 OVT        : \(card.ovt)
        🟢 VTT        : \(card.auxVerb) \(card.vtt)
        ⚡ Irregular  : \(card.isIrregular)
        🇬🇧 English    : \(card.english ?? "-")
        🇪🇸 Spanish    : \(card.spanish ?? "-")
        💬 Sentences  :
        \(String(describing: card.sentences?.enumerated().map { "   \($0.offset + 1). \($0.element)" }.joined(separator: "\n")))
        ══════════════════════════════════════════
        ✅ SUCCESS
        ══════════════════════════════════════════
        """)

        return card
    }

    // MARK: - Debug Helpers

    private func debugLog(_ message: String) {
        guard debugEnabled else { return }
        print("[AnthropicVerbRepository]" + message)
    }

    private func formatHeaders(_ headers: [String: String]?) -> String {
        guard let headers, !headers.isEmpty else { return "  (none)" }
        return headers
            .sorted { $0.key < $1.key }
            .map { key, value in
                let isSensitive = key.lowercased().contains("api-key")
                    || key.lowercased().contains("authorization")
                let displayValue = isSensitive
                    ? String(repeating: "•", count: max(0, value.count - 4)) + value.suffix(4)
                    : value
                return "  \(key): \(displayValue)"
            }
            .joined(separator: "\n")
    }

    // MARK: - Errors

    enum APIError: LocalizedError {
        case badResponse(statusCode: Int, body: String)
        case noContent
        case parseError
        case decodingError(detail: String)

        var errorDescription: String? {
            switch self {
            case .badResponse(let code, let body):
                return "HTTP \(code). Response: \(body.prefix(300))"
            case .noContent:
                return "Empty response from API."
            case .parseError:
                return "Could not convert response text to data."
            case .decodingError(let detail):
                return "JSON decode failed: \(detail)"
            }
        }
    }
}
