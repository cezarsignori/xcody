import Foundation
import Combine

class ChatService: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let mockResponses = [
        "I'm here to help! What can I do for you?",
        "That's an interesting question. Let me think about it...",
        "Based on my analysis, I would recommend...",
        "Could you please provide more details?",
        "I understand your request. Here's what I suggest..."
    ]
    
    func sendMessage(_ content: String) {
        let userMessage = ChatMessage(content: content, isUser: true)
        messages.append(userMessage)
        
        // Simulate AI response with delay
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                let response = self?.mockResponses.randomElement() ?? "I'm not sure how to respond to that."
                let aiMessage = ChatMessage(content: response, isUser: false)
                self?.messages.append(aiMessage)
            }
            .store(in: &cancellables)
    }
}
