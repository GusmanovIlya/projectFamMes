import Foundation

actor MockNotesRepository: NotesRepository {
    private var personal: [PersonalNote] = [
        .init(id: UUID().uuidString, title: nil, content: "Купить хлеб", updatedAt: .now),
        .init(id: UUID().uuidString, title: "Моя заметка", content: "Построить дом", updatedAt: .now - 1000),
    ]
    
    private var shared: [SharedNote] = [
            .init(
                id: UUID().uuidString,
                roomId: UUID().uuidString,
                title: "Общая заметка",
                content: "Тест1",
                members: [NoteMember(id: UUID().uuidString), NoteMember(id: UUID().uuidString)],
                updatedAt: .now
            )
        ]

    func fetchPersonalNotes() async throws -> [PersonalNote] {
        personal.sorted { $0.updatedAt > $1.updatedAt }
    }

    func createPersonalNote(title: String?, content: String) async throws -> PersonalNote {
        let note = PersonalNote(
            id: UUID().uuidString,
            title: title,
            content: content,
            updatedAt: .now
        )
        personal.insert(note, at: 0)
        return note
    }

    func updatePersonalNote(id: EntityID, title: String?, content: String) async throws -> PersonalNote {
        guard let index = personal.firstIndex(where: { $0.id == id }) else {
            throw NSError(domain: "MockNotesRepository", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "Заметка не найдена"
            ])
        }

        personal[index].title = title
        personal[index].content = content
        personal[index].updatedAt = .now

        return personal[index]
    }

    func deletePersonalNote(id: EntityID) async throws {
        guard let index = personal.firstIndex(where: { $0.id == id }) else {
            throw NSError(domain: "MockNotesRepository", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "Заметка не найдена"
            ])
        }

        personal.remove(at: index)
    }
    
    func fetchSharedNotes() async throws -> [SharedNote] {
        shared.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    func createSharedNote(roomId: EntityID, title: String?, content: String, members: [NoteMember]) async throws -> SharedNote {
        let note = SharedNote(
            id: UUID().uuidString,
            roomId: roomId,
            title: title,
            content: content,
            members: members,
            updatedAt: .now
        )
        shared.insert(note, at: 0)
        return note
    }
    
    func updateSharedNote(id: EntityID, title: String?, content: String, members: [NoteMember]) async throws -> SharedNote {
        guard let index = shared.firstIndex(where: { $0.id == id }) else {
            throw NSError(domain: "MockNotesRepository", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "Общая заметка не найдена"
            ])
        }

        shared[index].title = title
        shared[index].content = content
        shared[index].members = members
        shared[index].updatedAt = .now
        
        return shared[index]
    }
    
    func deleteSharedNote(id: EntityID) async throws {
        guard let index = shared.firstIndex(where: { $0.id == id }) else {
            throw NSError(domain: "MockNotesRepository", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "Общая заметка не найдена"
            ])
        }
        
        shared.remove(at: index)
    }
}
