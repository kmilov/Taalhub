import SwiftUI

struct InputBarView: View {
    @Binding var text: String
    let isLoading: Bool
    var focused: FocusState<Bool>.Binding
    let onSend: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.appDivider)
                .frame(height: 1)

            HStack(spacing: 12) {
                TextField("Type a Dutch infinitive…", text: $text)
                    .font(.custom("Georgia-Italic", size: 16))
                    .foregroundColor(Color.appText)
                    .tint(Color.appGold)
                    .focused(focused)
                    .onSubmit(onSend)
                    .disabled(isLoading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.appSurface)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(focused.wrappedValue ? Color.appGold.opacity(0.5) : Color.appDivider, lineWidth: 1)
                    )

                Button(action: onSend) {
                    ZStack {
                        Circle()
                            .fill(text.trimmingCharacters(in: .whitespaces).isEmpty || isLoading
                                  ? Color.appGold.opacity(0.3)
                                  : Color.appGold)
                            .frame(width: 44, height: 44)

                        if isLoading {
                            ProgressView()
                                .tint(.black)
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
                .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.appBackground)
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @FocusState var focused: Bool

    InputBarView(
        text: $text,
        isLoading: false,
        focused: $focused,
        onSend: {}
    )
}
