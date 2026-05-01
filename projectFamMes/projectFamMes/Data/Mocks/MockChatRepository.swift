import Foundation

actor MockChatRepository: ChatRepository {
    private var chats: [Chat] = [
        Chat(
            id: "room_ilya",
            avatar: "avatar1",
            name: "Илья",
            username: "ilya",
            lastMessage: "Сделать вход для пользователей",
            time: "12:45"
        ),
        Chat(
            id: "room_alexey",
            avatar: "avatar2",
            name: "Алексей",
            username: "alexey",
            lastMessage: "Создать бд для хранения",
            time: "11:20"
        ),
        Chat(
            id: "room_maria",
            avatar: "avatar3",
            name: "Мария",
            username: "maria",
            lastMessage: "Добавить общие заметки, пока можно только парные",
            time: "10:05"
        )
    ]

    private var allUsers: [UserSummary] = [
        UserSummary(id: "user_ilya", name: "Илья", username: "ilya"),
        UserSummary(id: "user_alexey", name: "Алексей", username: "alexey"),
        UserSummary(id: "user_maria", name: "Мария", username: "maria"),
        UserSummary(id: "user_kirill", name: "Кирилл", username: "kirill"),
        UserSummary(id: "user_arina", name: "Арина", username: "arina")
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
        if !chats.contains(where: { $0.id == roomId }) {
            let username = roomId.replacingOccurrences(of: "room_", with: "")
            if let user = allUsers.first(where: { normalize($0.username) == normalize(username) }) {
                let newChat = Chat(
                    id: roomId,
                    avatar: avatarName(for: user),
                    name: user.name,
                    username: user.username,
                    lastMessage: "",
                    time: ""
                )
                chats.insert(newChat, at: 0)
            }
        }

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

            let updatedChat = chats.remove(at: index)
            chats.insert(updatedChat, at: 0)
        }

        return message
    }

    func fetchAllUsers() async throws -> [UserSummary] {
        allUsers
    }

    func searchAllUsers(byUsername query: String) async throws -> [UserSummary] {
        let trimmed = normalize(query)
        guard !trimmed.isEmpty else { return allUsers }

        return allUsers.filter {
            normalize($0.name).contains(trimmed) ||
            normalize($0.username).contains(trimmed)
        }
    }

    func fetchKnownUsers() async throws -> [UserSummary] {
        let usernamesInChats = Set(chats.map { normalize($0.username) })

        return allUsers.filter { usernamesInChats.contains(normalize($0.username)) }
    }

    private func avatarName(for user: UserSummary) -> String {
        switch normalize(user.username) {
        case "ilya":
            return "avatar1"
        case "alexey":
            return "avatar2"
        case "maria":
            return "avatar3"
        default:
            return "avatar4"
        }
    }

    private func normalize(_ text: String) -> String {
        text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "@", with: "")
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
