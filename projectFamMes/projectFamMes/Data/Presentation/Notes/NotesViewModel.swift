import Foundation
import Observation

@MainActor
@Observable
final class NotesViewModel {
    private let repository: NotesRepository

    var personalNotes: [PersonalNote] = []
    var sharedNotes: [SharedNote] = []

    var isLoading = false
    var errorMessage: String?

    init(repository: NotesRepository) {
        self.repository = repository
    }

    func loadPersonalNotes() async {
        isLoading = true
        errorMessage = nil

        do {
            personalNotes = try await repository.fetchPersonalNotes()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadSharedNotes() async {
        isLoading = true
        errorMessage = nil

        do {
            sharedNotes = try await repository.fetchSharedNotes()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func createPersonalNote(title: String?, content: String) async {
        errorMessage = nil

        do {
            let newNote = try await repository.createPersonalNote(title: title, content: content)
            personalNotes.insert(newNote, at: 0)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func createSharedNote(
        roomId: EntityID,
        title: String?,
        content: String,
        members: [NoteMember]
    ) async {
        errorMessage = nil

        do {
            let newNote = try await repository.createSharedNote(
                roomId: roomId,
                title: title,
                content: content,
                members: members
            )
            sharedNotes.insert(newNote, at: 0)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updatePersonalNote(id: EntityID, title: String?, content: String) async {
        errorMessage = nil

        do {
            let updatedNote = try await repository.updatePersonalNote(
                id: id,
                title: title,
                content: content
            )

            if let index = personalNotes.firstIndex(where: { $0.id == id }) {
                personalNotes[index] = updatedNote
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateSharedNote(
        id: EntityID,
        title: String?,
        content: String,
        members: [NoteMember]
    ) async {
        errorMessage = nil

        do {
            let updatedNote = try await repository.updateSharedNote(
                id: id,
                title: title,
                content: content,
                members: members
            )

            if let index = sharedNotes.firstIndex(where: { $0.id == id }) {
                sharedNotes[index] = updatedNote
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deletePersonalNote(id: EntityID) async {
        errorMessage = nil

        do {
            try await repository.deletePersonalNote(id: id)
            personalNotes.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteSharedNote(id: EntityID) async {
        errorMessage = nil

        do {
            try await repository.deleteSharedNote(id: id)
            sharedNotes.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
