import SwiftUI

struct Chat: Identifiable {
    let id = UUID()
    let avatar: String
    let name: String
    let lastMessage: String
    let time: String
}

struct ChatsHomeView: View {
    let chats: [Chat] = [
        Chat(
            avatar: "avatar1",
            name: "Илья",
            lastMessage: "Привет, как дела?",
            time: "12:45"
        ),
        Chat(
            avatar: "avatar1",
            name: "Алексей",
            lastMessage: "Скинь, пожалуйста, код проекта",
            time: "11:20"
        ),
        Chat(
            avatar: "avatar1",
            name: "Мария",
            lastMessage: "Сегодня созвон в 18:00",
            time: "10:05"
        ),
        Chat(
            avatar: "avatar1",
            name: "Дима",
            lastMessage: "Я уже подъехал",
            time: "09:41"
        ),
        Chat(
            avatar: "avatar1",
            name: "София",
            lastMessage: "Спасибо большое 😊",
            time: "Вчера"
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(chats) { chat in
                        NavigationLink {
                            ChatView(chat: chat)
                        } label: {
                            ChatRowView(chat: chat)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Чаты")
        }
    }
}

struct ChatRowView: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 12) {
            Image(chat.avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 58, height: 58)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 2)
                }
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(chat.name)
                        .font(.headline)

                    Spacer()

                    Text(chat.time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    ChatsHomeView()
}
