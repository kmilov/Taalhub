import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var inputFocused: Bool

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HeaderView(
                    onDeleteAll: viewModel.deleteAllSavedVerbs,
                    isLoading: viewModel.isLoading
                )

                // Chat scroll area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Welcome / quick verbs
                            if viewModel.messages.isEmpty {
                                WelcomeView(quickVerbs: viewModel.quickVerbs) { verb in
                                    viewModel.sendQuickVerb(verb)
                                }
                                .padding(.top, 24)
                            }

                            // Messages
                            ForEach(viewModel.messages) { message in
                                MessageBubbleView(message: message)
                                    .padding(.horizontal, 16)
                                    .id(message.id)
                            }

                            // Scroll anchor
                            Color.clear
                                .frame(height: 1)
                                .id("bottom")
                        }
                        .padding(.bottom, 12)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                    .onReceive(viewModel.$messages) { _ in
                        // Ensure we scroll after layout updates when new content arrives asynchronously
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                    }
                }

                // Input bar
                InputBarView(
                    text: $viewModel.inputText,
                    isLoading: viewModel.isLoading,
                    focused: $inputFocused,
                    onSend: viewModel.sendVerb
                )
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
