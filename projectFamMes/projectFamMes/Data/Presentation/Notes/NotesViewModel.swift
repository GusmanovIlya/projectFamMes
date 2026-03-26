import Foundation
import Observation

@MainActor
@Observable
final class NotesViewModel {
    private let repo: NotesRepository

    var notes: [PersonalNote] = []
    var errorMessage: String?

    init(repo: NotesRepository) {
        self.repo = repo
    }

    func load() async {
        do {
            notes = try await repo.fetchPersonalNotes()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func create(title: String?, content: String) async {
        do {
            let created = try await repo.createPersonalNote(title: title, content: content)
            notes.insert(created, at: 0)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func update(id: EntityID, title: String?, content: String) async {
        do {
            let updated = try await repo.updatePersonalNote(id: id, title: title, content: content)

            if let index = notes.firstIndex(where: { $0.id == id }) {
                notes[index] = updated
            }
            notes.sort { $0.updatedAt > $1.updatedAt }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(id: EntityID) async {
        do {
            try await repo.deletePersonalNote(id: id)
            notes.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
