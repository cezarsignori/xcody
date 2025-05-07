import SwiftUI

struct ChatView: View {
    @StateObject private var chatService = ChatService()
    @State private var messageText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            // Chat header
            ChatHeader()
            
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(chatService.messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding()
                }
                .onChange(of: chatService.messages) {
                    withAnimation {
                        proxy.scrollTo(chatService.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Input area
            ChatInputField(
                text: $messageText,
                isFocused: _isFocused,
                onSend: {
                    guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    chatService.sendMessage(messageText)
                    messageText = ""
                }
            )
        }
    }
}

struct ChatHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "brain.head.profile")
                .font(.title2)
            Text("AI Assistant")
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp.formatted(.dateTime.hour().minute()))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

struct ChatInputField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    var onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextEditor(text: $text)
                        .focused($isFocused)
                        .frame(height: max(40, min(120, textHeight())))
                        .scrollContentBackground(.hidden)
                        .cornerRadius(8)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    private func textHeight() -> CGFloat {
            let lineHeight: CGFloat = 20 // Approximate height of a single line
            let numberOfLines = text.components(separatedBy: "\n").count
            return CGFloat(numberOfLines) * lineHeight
        }
}

// Preview provider
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
