import Foundation

actor MockNotesRepository: NotesRepository {
    private var personal: [PersonalNote] = [
        .init(id: UUID().uuidString, title: nil, content: "Купить хлеб", updatedAt: .now),
        .init(id: UUID().uuidString, title: "Моя заметка", content: "Построить дом", updatedAt: .now - 1000),
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
}
