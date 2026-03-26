import Foundation

protocol NotesRepository {
    func fetchPersonalNotes() async throws -> [PersonalNote]
    func createPersonalNote(title: String?, content: String) async throws -> PersonalNote
    func updatePersonalNote(id: EntityID, title: String?, content: String) async throws -> PersonalNote
    func deletePersonalNote(id: EntityID) async throws
}
