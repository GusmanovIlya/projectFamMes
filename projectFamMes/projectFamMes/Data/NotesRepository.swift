import Foundation

protocol NotesStorage {
    func fetchPersonalNotes() async throws -> [PersonalNote]
    func createPersonalNote(title: String?, content: String) async throws -> PersonalNote
    func updatePersonalNote(id: EntityID, title: String?, content: String) async throws -> PersonalNote
    func deletePersonalNote(id: EntityID) async throws
    
    func fetchSharedNotes() async throws -> [SharedNote]
    func createSharedNote(
        roomId: EntityID,
        title: String?,
        content: String,
        members: [NoteMember]
    ) async throws -> SharedNote
    func updateSharedNote(
        id: EntityID,
        title: String?,
        content: String,
        members: [NoteMember]
    ) async throws -> SharedNote
    func deleteSharedNote(id: EntityID) async throws
}

// Временно оставляем старое имя, чтобы не сломать существующие классы.
// Позже спокойно переименуем Repository в Storage.
typealias NotesRepository = NotesStorage
