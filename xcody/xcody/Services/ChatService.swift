import Foundation
import Combine

class ChatService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    private let mockResponses: [ChatMessage] = [
        ChatMessage(content: "Hello! How can I help you today?", isUser: false),
        ChatMessage(
            content: """
            struct ContentView: View {
                var body: some View {
                    Text("Hello, World!")
                }
            }
            """,
            isUser: false,
            type: .code(language: "swift")
        ),
        ChatMessage(content: "Can you explain this code?", isUser: false),
        ChatMessage(content: "This is a basic SwiftUI view structure.", isUser: false)
    ]
    private var mockCurrentMessageIndex = -1;
    
    private var cancellables = Set<AnyCancellable>()
    
    func sendMessage(_ content: String) {
        let userMessage = ChatMessage(content: content, isUser: true)
        messages.append(userMessage)
        
        // Simulate AI response with delay
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                guard let self = self else { return }
                            
                self.mockCurrentMessageIndex += 1
                
                let response: ChatMessage
                if self.mockCurrentMessageIndex < self.mockResponses.count {
                    response = self.mockResponses[self.mockCurrentMessageIndex]
                } else {
                    response = ChatMessage(content: "I can't respond to that", isUser: false)
                }
                
                self.messages.append(response)
            }
            .store(in: &cancellables)
    }
}
