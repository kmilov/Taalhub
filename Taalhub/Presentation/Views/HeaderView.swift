import SwiftUI

struct HeaderView: View {
    let onDeleteAll: () -> Void
    let isLoading: Bool
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 4) {
            Button { selection = .chat } label: {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(selection == .chat ? Color("Gold") : Color("Muted"))
                    .frame(width: 44, height: 44)
            }
            Button { selection = .savedWords } label: {
                Image(systemName: "bookmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(selection == .savedWords ? Color("Gold") : Color("Muted"))
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Button(action: onDeleteAll) {
                ZStack {
                    Circle()
                        .fill(Color("Irregular").opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.red.opacity(0.2))
                }
            }
            .disabled(isLoading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

#Preview {
    HeaderView(onDeleteAll: {}, isLoading: false, selection: .constant(.chat))
        .background(Color.appBackground)
}
