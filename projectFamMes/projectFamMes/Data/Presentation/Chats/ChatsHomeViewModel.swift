import Foundation
import Observation

@MainActor
@Observable
final class ChatsHomeViewModel {
    private let repo: ChatRepository

    var chats: [Chat] = []
    var errorMessage: String?

    init(repo: ChatRepository) {
        self.repo = repo
    }

    func load() async {
        do {
            chats = try await repo.fetchChats()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
