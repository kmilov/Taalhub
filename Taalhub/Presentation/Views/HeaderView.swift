import SwiftUI

struct HeaderView: View {
    let onDeleteAll: () -> Void
    let isLoading: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
//                Text("Werkwoorden")
//                    .font(.custom("Georgia-BoldItalic", size: 22))
//                    .foregroundColor(Color.appGold)
//                Text("Dutch Verb Trainer")
//                    .font(.system(size: 11, weight: .medium, design: .monospaced))
//                    .foregroundColor(Color.appMuted)
//                    .tracking(2)
//                    .textCase(.uppercase)
            }
            Spacer()
            
//            Image(systemName: "flag.fill")
//                .foregroundColor(Color.appGold.opacity(0.6))
//                .font(.title2)

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
        // .background(Color)
        // .overlay(
        //     Rectangle()
        //         .frame(height: 1),
        //         alignment: .bottom
        // )
    }
}

#Preview {
    HeaderView(onDeleteAll: {}, isLoading: false)
}
