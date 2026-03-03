# Taalhub — Architecture Reference

Dutch verb conjugation app for iOS. Users type a Dutch infinitive, the app calls Claude via the Anthropic API, returns a verb card with conjugations and example sentences, and persists the result locally.

---

## Layer Overview

```
Presentation  ←  Domain  ←  Infrastructure
(SwiftUI)         (pure)      (CoreData, Network)
```

Clean Architecture. The Domain layer has no imports — only protocols and plain structs.

---

## Domain Layer

### `VerbCard` — `Domain/Entities/VerbCard.swift`
The core model. All layers pass this struct around.
```
infinitive  String       Dutch base form ("schrijven")
vtt         String       Voltooid deelwoord ("geschreven")
ovt         String       Onvoltooid verleden tijd ("schreef")
isIrregular Bool
sentences   [String]?    Up to 3 example sentences
auxVerb     String       "hebben" or "zijn"
english     String       English translation of the verb
spanish     String       Spanish translation of the verb
```

### Protocols
- `VerbConjugationRepository` — `fetchConjugation(for:) async throws -> VerbCard`
- `SavedVerbRepository` — `fetchAll()`, `save(_:)`, `deleteAll()`

### `ConjugateVerbUseCase` — `Domain/UseCases/ConjugateVerbUseCase.swift`
Fetches from the API, then auto-saves to persistence. Single method: `execute(infinitive:)`.

---

## Infrastructure Layer

### Network — `Infrastructure/Network/`
- **`AnthropicVerbRepository`** — implements `VerbConjugationRepository`. Calls `claude-opus-4-5` via the Anthropic messages API. Sends the Dutch infinitive, receives JSON with conjugations + translations. DTOs live in `DTOs/AnthropicModels.swift`.
- API key is hardcoded in this file (known issue).

### Persistence — `Infrastructure/Persistence/`
- **`PersistenceController`** — singleton CoreData stack, container name `VerbCardsModel`.
- **`VerbEntity`** — NSManagedObject with fields: `infinitive`, `pastTense`, `pastParticiple`, `sentences` (Transformable), `english`, `spanish`.
- **`CoreDataVerbRepository`** — implements `SavedVerbRepository`. Uses batch delete for `deleteAll()`.

---

## Presentation Layer

### ViewModel — `Presentation/ViewModels/ChatViewModel.swift`
`@MainActor ObservableObject`. The single source of truth.
- `messages: [ChatMessage]` — the full chat history, loaded from CoreData on init
- `sendVerb()` — appends user + loading messages, runs use case, swaps loading for card or error
- `deleteAllSavedVerbs()` — calls repo + removes verbCard messages from state
- `quickVerbs` — preset list of 10 verbs for fast access

### `ChatMessage` — `Presentation/Models/ChatMessage.swift`
Enum wrapper displayed in the chat scroll view:
```
.userInput(String)   User typed a verb
.verbCard(VerbCard)  API returned a card
.loading(String)     Waiting for API
.error(String)       Something failed
```

### Views — `Presentation/Views/`

**Top level**
- `ContentView` — `ScrollViewReader` chat list + `InputBarView` at bottom
- `HeaderView` — "Delete all" button
- `WelcomeView` — shown when messages is empty; quick verb buttons
- `InputBarView` — `TextField` + send button

**Message bubbles — `Views/MessageBubbles/`**
- `MessageBubbleView` — routes `ChatMessage` to the correct bubble view
- `UserBubble`, `ErrorBubble`, `LoadingBubble` — self-explanatory

**Verb card — `Views/VerbCard/`**
- `VerbCardBubble` — 3D flip container. Tap (single) flips front ↔ back via `rotation3DEffect`.
- `CardFrontView` — shows infinitive, conjugations (vtt/ovt), aux verb, regular/irregular badge
- `CardBackView` — shows example sentences using `SelectableSentenceView`
- `SelectableSentenceView` — splits sentences into word tokens, wraps them in `FlowLayout`, attaches long-press + popover to each word
- `WordTranslationPopup` — popover content: word in gold, EN row, ES row, "Save word" button (presentation only)

---

## Extensions — `Extensions/`
- **`Colors.swift`** — `Color(hex:)` initializer + named static colors (`appBackground`, `appGold`, etc.). Colors are also registered in `Assets.xcassets` as named color sets (e.g. `Color("Gold")`).
- **`ViewExtensions.swift`** — `cornerRadius(_:corners:)` for selective corner rounding via `UIRectCorner`.

---

## Color Palette (dark-only)
| Name        | Hex       | Usage                        |
|-------------|-----------|------------------------------|
| Background  | `#0E0E0E` | Root background              |
| Surface     | `#161616` | Chat bubbles                 |
| SurfaceAlt  | `#1A1A18` | Verb cards                   |
| Gold        | `#C9A96E` | Accent, verb stems, headers  |
| Muted       | `#665E52` | Labels, hints                |
| TextPrimary | `#F0E6D3` | Body text                    |
| Divider     | `#2A2A2A` | Separators                   |
| Irregular   | `#E07A5F` | Irregular verb badge         |
| Regular     | `#81B29A` | Regular verb badge           |

---

## Data Flow

```
User types verb
  → ChatViewModel.sendVerb()
    → ConjugateVerbUseCase.execute()
      → AnthropicVerbRepository.fetchConjugation()  [API call]
      → CoreDataVerbRepository.save()               [auto-persist]
    → messages.append(.verbCard(card))
      → VerbCardBubble (flip card UI)
        → CardFrontView (conjugations)
        → CardBackView → SelectableSentenceView (long-press → WordTranslationPopup)
```

---

## Key Notes for Future Work
- **Word translation** (`WordTranslationPopup`) is hardcoded — EN/ES placeholders only. Hook into `AnthropicVerbRepository` or a new `WordTranslationRepository` when ready.
- **Save word** button in popup is presentation-only. Needs a `WordTranslation` model + persistence layer.
- `VerbEntity` stores `english` and `spanish` but the CoreData schema (`VerbCardsModel.xcdatamodeld`) may need migration if fields were added after initial creation — verify before shipping.
- API key is hardcoded in `AnthropicVerbRepository.swift:6`. Move to a config file or environment variable.
