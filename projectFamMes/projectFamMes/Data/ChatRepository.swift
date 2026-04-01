import Foundation

protocol ChatRepository {
    func fetchChats() async throws -> [Chat]
    func fetchMessages(roomId: EntityID) async throws -> [Message]
    func sendMessage(roomId: EntityID, senderId: EntityID, text: String) async throws -> Message
}
