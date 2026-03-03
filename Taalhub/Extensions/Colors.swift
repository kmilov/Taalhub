import SwiftUI

// MARK: - Color Palette
// Add these to your Assets.xcassets as Color Sets, or use the extension below.
// Dark theme optimized for a rich editorial look.

extension Color {
    static let appBackground = Color(hex: "#0E0E0E")
    static let appSurface    = Color(hex: "#161616")
    static let appSurfaceAlt = Color(hex: "#1A1A18")
    static let appDivider    = Color(hex: "#2A2A2A")
    static let appGold       = Color(hex: "#C9A96E")
    static let appMuted      = Color(hex: "#665E52")
    static let appText       = Color(hex: "#F0E6D3")
    static let appIrregular  = Color(hex: "#E07A5F")
    static let appRegular    = Color(hex: "#81B29A")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

/*
 ──────────────────────────────────────────────────
 ASSETS.XCASSETS SETUP INSTRUCTIONS
 ──────────────────────────────────────────────────
 In Xcode, open Assets.xcassets and add these Color Sets.
 Set "Appearances" to "Any, Dark" and use the same hex
 for both (app is dark-only) OR just use the extension above
 by referencing Color("Background") etc. after adding them.

 Color Name   → Hex Value
 ─────────────────────────
 Background   → #0E0E0E
 Surface      → #161616
 SurfaceAlt   → #1A1A18
 Divider      → #2A2A2A
 Gold         → #C9A96E
 Muted        → #665E52
 TextPrimary  → #F0E6D3
 Irregular    → #E07A5F
 Regular      → #81B29A

 ──────────────────────────────────────────────────
 ALTERNATIVELY: Replace Color("X") with Color.appX
 in ContentView.swift to skip Asset Catalog entirely.
 ──────────────────────────────────────────────────
*/
