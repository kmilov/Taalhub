# 🇳🇱 Werkwoorden — Dutch Verb Trainer

A SwiftUI chat-style app that generates Dutch verb conjugations using the Anthropic API.

## Features
- Chat-like interface: type a verb, get a card back
- Flip animation to reveal example sentences
- Shows OVT (Onvoltooid Verleden Tijd) and VTT (Voltooid Deelwoord)
- Indicates Regular vs Irregular verbs
- Shows auxiliary verb (hebben / zijn)
- 2 example sentences with verb highlighted

---

## Setup

### 1. Create Xcode Project
- Open Xcode → New Project → App
- Name: `DutchVerbs`, Interface: **SwiftUI**, Language: **Swift**
- Minimum deployment: **iOS 16+**

### 2. Add Files
Copy all `.swift` files into your project:
- `DutchVerbsApp.swift` (replace the generated one)
- `ContentView.swift` (replace the generated one)
- `Models.swift`
- `AnthropicService.swift`
- `ChatViewModel.swift`
- `Colors.swift`

### 3. Add Color Assets
In `Assets.xcassets`, add these **Color Sets** (set Appearances to "Any, Dark"):

| Name        | Hex       |
|-------------|-----------|
| Background  | #0E0E0E   |
| Surface     | #161616   |
| SurfaceAlt  | #1A1A18   |
| Divider     | #2A2A2A   |
| Gold        | #C9A96E   |
| Muted       | #665E52   |
| TextPrimary | #F0E6D3   |
| Irregular   | #E07A5F   |
| Regular     | #81B29A   |

### 4. Add Your API Key
In `AnthropicService.swift`, replace:
```swift
private let apiKey = "YOUR_ANTHROPIC_API_KEY"
```
with your actual key from [console.anthropic.com](https://console.anthropic.com).

> ⚠️ For production, store the key securely (Keychain, or proxy backend). Never ship API keys in client apps.

### 5. Run!
Build and run on simulator or device (iOS 16+).

---

## Usage
- Type any Dutch infinitive in the text bar (e.g. *werken*, *gaan*, *schrijven*)
- Tap **↑** or press Return to send
- Tap the card to flip between conjugations and example sentences
- Tap the quick-verb chips on the welcome screen to get started fast

---

## File Structure
```
DutchVerbs/
├── DutchVerbsApp.swift       # App entry point
├── ContentView.swift         # All UI views
├── ChatViewModel.swift       # State + logic
├── AnthropicService.swift    # API calls
├── Models.swift              # Data models
├── Colors.swift              # Color palette + setup guide
└── Assets.xcassets/          # Color sets (add manually)
```
