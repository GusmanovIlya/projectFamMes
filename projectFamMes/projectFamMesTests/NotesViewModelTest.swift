import XCTest
@testable import projectFamMes

@MainActor
final class NotesViewModelTests: XCTestCase {

    func testLoadNotesSuccessSetsContentState() async {
        let storage = MockNotesStorage(
            personalNotes: [
                PersonalNote(
                    id: "1",
                    title: "Тест",
                    content: "Тестовая заметка",
                    updatedAt: Date()
                )
            ],
            sharedNotes: []
        )

        let vm = NotesViewModel(storage: storage)

        await vm.reloadAll()

        XCTAssertEqual(vm.personalNotes.count, 1)
        XCTAssertEqual(vm.sharedNotes.count, 0)
        XCTAssertEqual(vm.state, .content)
    }

    func testLoadNotesEmptySetsEmptyState() async {
        let storage = MockNotesStorage(
            personalNotes: [],
            sharedNotes: []
        )

        let vm = NotesViewModel(storage: storage)

        await vm.reloadAll()

        XCTAssertEqual(vm.personalNotes.count, 0)
        XCTAssertEqual(vm.sharedNotes.count, 0)
        XCTAssertEqual(vm.state, .empty)
    }

    func testLoadNotesFailureSetsErrorState() async {
        let storage = MockNotesStorage(
            shouldThrowError: true
        )

        let vm = NotesViewModel(storage: storage)

        await vm.reloadAll()

        if case .error(let message) = vm.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Ожидали error state")
        }
    }

    func testCreatePersonalNoteAddsNote() async {
        let storage = MockNotesStorage(
            personalNotes: [],
            sharedNotes: []
        )

        let vm = NotesViewModel(storage: storage)

        await vm.createPersonalNote(
            title: "Новая заметка",
            content: "Контент"
        )

        XCTAssertEqual(vm.personalNotes.count, 1)
        XCTAssertEqual(vm.personalNotes.first?.title, "Новая заметка")
        XCTAssertEqual(vm.personalNotes.first?.content, "Контент")
        XCTAssertEqual(vm.state, .content)
    }

    func testDeletePersonalNoteRemovesNote() async {
        let note = PersonalNote(
            id: "1",
            title: "Удалить",
            content: "Контент",
            updatedAt: Date()
        )

        let storage = MockNotesStorage(
            personalNotes: [note],
            sharedNotes: []
        )

        let vm = NotesViewModel(storage: storage)

        await vm.reloadAll()
        await vm.deletePersonalNote(id: "1")

        XCTAssertEqual(vm.personalNotes.count, 0)
        XCTAssertEqual(vm.state, .empty)
    }
}


private final class MockNotesStorage: NotesStorage {
    private var personalNotes: [PersonalNote]
    private var sharedNotes: [SharedNote]
    private let shouldThrowError: Bool

    init(
        personalNotes: [PersonalNote] = [],
        sharedNotes: [SharedNote] = [],
        shouldThrowError: Bool = false
    ) {
        self.personalNotes = personalNotes
        self.sharedNotes = sharedNotes
        self.shouldThrowError = shouldThrowError
    }

    func fetchPersonalNotes() async throws -> [PersonalNote] {
        if shouldThrowError {
            throw TestError.failed
        }

        return personalNotes
    }

    func createPersonalNote(
        title: String?,
        content: String
    ) async throws -> PersonalNote {
        if shouldThrowError {
            throw TestError.failed
        }

        let note = PersonalNote(
            id: UUID().uuidString,
            title: title,
            content: content,
            updatedAt: Date()
        )

        personalNotes.insert(note, at: 0)

        return note
    }

    func updatePersonalNote(
        id: EntityID,
        title: String?,
        content: String
    ) async throws -> PersonalNote {
        if shouldThrowError {
            throw TestError.failed
        }

        guard let index = personalNotes.firstIndex(where: { $0.id == id }) else {
            throw TestError.notFound
        }

        personalNotes[index].title = title
        personalNotes[index].content = content
        personalNotes[index].updatedAt = Date()

        return personalNotes[index]
    }

    func deletePersonalNote(id: EntityID) async throws {
        if shouldThrowError {
            throw TestError.failed
        }

        personalNotes.removeAll { $0.id == id }
    }

    func fetchSharedNotes() async throws -> [SharedNote] {
        if shouldThrowError {
            throw TestError.failed
        }

        return sharedNotes
    }

    func createSharedNote(
        roomId: EntityID,
        title: String?,
        content: String,
        members: [NoteMember]
    ) async throws -> SharedNote {
        if shouldThrowError {
            throw TestError.failed
        }

        let note = SharedNote(
            id: UUID().uuidString,
            roomId: roomId,
            title: title,
            content: content,
            members: members,
            updatedAt: Date()
        )

        sharedNotes.insert(note, at: 0)

        return note
    }

    func updateSharedNote(
        id: EntityID,
        title: String?,
        content: String,
        members: [NoteMember]
    ) async throws -> SharedNote {
        if shouldThrowError {
            throw TestError.failed
        }

        guard let index = sharedNotes.firstIndex(where: { $0.id == id }) else {
            throw TestError.notFound
        }

        sharedNotes[index].title = title
        sharedNotes[index].content = content
        sharedNotes[index].members = members
        sharedNotes[index].updatedAt = Date()

        return sharedNotes[index]
    }

    func deleteSharedNote(id: EntityID) async throws {
        if shouldThrowError {
            throw TestError.failed
        }

        sharedNotes.removeAll { $0.id == id }
    }
}

private enum TestError: LocalizedError {
    case failed
    case notFound

    var errorDescription: String? {
        switch self {
        case .failed:
            return "Тестовая ошибка"
        case .notFound:
            return "Объект не найден"
        }
    }
}
