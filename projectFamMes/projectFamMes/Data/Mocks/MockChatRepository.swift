import Foundation

actor MockChatRepository: ChatRepository {
    private var chats: [Chat] = [
        Chat(
            id: "room_ilya",
            avatar: "avatar1",
            name: "Илья",
            lastMessage: "Сделать вход для пользователей",
            time: "12:45"
        ),
        Chat(
            id: "room_alexey",
            avatar: "avatar2",
            name: "Алексей",
            lastMessage: "Создать бд для хранения",
            time: "11:20"
        ),
        Chat(
            id: "room_maria",
            avatar: "avatar3",
            name: "Мария",
            lastMessage: "Добавить общие заметки, пока можно только парные",
            time: "10:05"
        )
    ]

    private var messagesByRoomId: [EntityID: [Message]] = [
        "room_ilya": [
            Message(
                id: UUID().uuidString,
                roomId: "room_ilya",
                senderId: "Илья",
                text: "Привет! Ты сможешь посмотреть заметки сегодня?",
                createdAt: .now.addingTimeInterval(-7600),
                status: .read
            ),
            Message(
                id: UUID().uuidString,
                roomId: "room_ilya",
                senderId: "me",
                text: "Да, конечно. Уже почти закончил экран редактирования.",
                createdAt: .now.addingTimeInterval(-7200),
                status: .read
            ),
            Message(
                id: UUID().uuidString,
                roomId: "room_ilya",
                senderId: "Илья",
                text: "Сделать вход для пользователей",
                createdAt: .now.addingTimeInterval(-1800),
                status: .delivered
            )
        ],
        "room_alexey": [
            Message(
                id: UUID().uuidString,
                roomId: "room_alexey",
                senderId: "Алексей",
                text: "Скинь, пожалуйста, код проекта",
                createdAt: .now.addingTimeInterval(-3600),
                status: .delivered
            )
        ],
        "room_maria": [
            Message(
                id: UUID().uuidString,
                roomId: "room_maria",
                senderId: "Мария",
                text: "Сегодня созвон в 18:00",
                createdAt: .now.addingTimeInterval(-5400),
                status: .read
            )
        ]
    ]

    func fetchChats() async throws -> [Chat] {
        chats
    }

    func fetchMessages(roomId: EntityID) async throws -> [Message] {
        messagesByRoomId[roomId, default: []]
            .sorted { $0.createdAt < $1.createdAt }
    }

    func sendMessage(roomId: EntityID, senderId: EntityID, text: String) async throws -> Message {
        let message = Message(
            id: UUID().uuidString,
            roomId: roomId,
            senderId: senderId,
            text: text,
            createdAt: .now,
            status: .sent
        )

        messagesByRoomId[roomId, default: []].append(message)

        if let index = chats.firstIndex(where: { $0.id == roomId }) {
            chats[index].lastMessage = text
            chats[index].time = Self.timeFormatter.string(from: .now)
        }

        return message
    }
}

private extension MockChatRepository {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
}
