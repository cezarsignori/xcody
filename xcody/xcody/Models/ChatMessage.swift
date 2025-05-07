import Foundation

enum MessageType : Equatable {
    case text
    case code(language: String)
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    let type: MessageType
    
    init(id: UUID = UUID(), content: String, isUser: Bool, type: MessageType = .text, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.type = type
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
            lhs.id == rhs.id &&
            lhs.content == rhs.content &&
            lhs.isUser == rhs.isUser &&
            lhs.timestamp == rhs.timestamp &&
            lhs.type == rhs.type
        }
}
