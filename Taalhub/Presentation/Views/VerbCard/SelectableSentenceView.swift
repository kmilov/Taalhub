import SwiftUI

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                totalHeight += rowHeight + spacing
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        totalHeight += rowHeight
        return CGSize(width: maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentY += rowHeight + spacing
                currentX = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - SelectableSentenceView

struct SelectableSentenceView: View {
    let sentence: String
    let infinitive: String

    @State private var selectedWord: String? = nil

    var tokens: [String] {
        sentence.components(separatedBy: " ").filter { !$0.isEmpty }
    }

    var body: some View {
        FlowLayout(spacing: 4) {
            ForEach(tokens, id: \.self) { token in
                let clean = token.trimmingCharacters(in: .punctuationCharacters)
                let highlighted = isVerbStem(clean)

                Text(token)
                    .font(highlighted
                        ? .system(size: 15, weight: .bold, design: .serif)
                        : .custom("Georgia-Italic", size: 32))
                    .foregroundColor(highlighted ? Color("Gold") : Color("TextPrimary"))
                    .onLongPressGesture(minimumDuration: 0.4) {
                        selectedWord = clean.isEmpty ? token : clean
                    }
                    .popover(
                        isPresented: Binding(
                            get: { selectedWord == (clean.isEmpty ? token : clean) },
                            set: { if !$0 { selectedWord = nil } }
                        )
                    ) {
                        WordTranslationPopup(word: clean.isEmpty ? token : clean)
                            .presentationCompactAdaptation(.none)
                    }
            }
        }
    }

    private func isVerbStem(_ word: String) -> Bool {
        let stem = String(infinitive.dropLast(infinitive.hasSuffix("en") ? 2 : 0)).lowercased()
        return stem.count >= 3 && word.lowercased().hasPrefix(stem)
    }
}
