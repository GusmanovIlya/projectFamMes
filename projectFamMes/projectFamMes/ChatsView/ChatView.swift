import SwiftUI

struct ChatView: View {
    let chat: Chat

    @State private var draft = ""

    private let currentUserId = "me"

    private var messages: [Message] {
        [
            Message(
                id: UUID().uuidString,
                roomId: chat.id.uuidString,
                senderId: chat.name,
                text: "Привет! Ты сможешь посмотреть заметки сегодня?",
                createdAt: .now.addingTimeInterval(-7600),
                status: .read
            ),
            Message(
                id: UUID().uuidString,
                roomId: chat.id.uuidString,
                senderId: currentUserId,
                text: "Да, конечно. Уже почти закончил экран редактирования.",
                createdAt: .now.addingTimeInterval(-7200),
                status: .read
            ),
            Message(
                id: UUID().uuidString,
                roomId: chat.id.uuidString,
                senderId: chat.name,
                text: chat.lastMessage,
                createdAt: .now.addingTimeInterval(-1800),
                status: .delivered
            )
        ]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(
                            text: message.text,
                            time: message.createdAt.formatted(date: .omitted, time: .shortened),
                            isOutgoing: message.senderId == currentUserId
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 90)
            }

            composer
        }
        .navigationTitle(chat.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(chat.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
                    .clipShape(Circle())
            }
        }
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Сообщение", text: $draft, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button {
                draft = ""
            } label: {
                Image(systemName: "arrow.up")
                    .font(.headline)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.borderedProminent)
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}

private struct MessageBubble: View {
    let text: String
    let time: String
    let isOutgoing: Bool

    var body: some View {
        HStack {
            if isOutgoing { Spacer(minLength: 48) }

            VStack(alignment: .leading, spacing: 6) {
                Text(text)
                    .font(.body)

                Text(time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isOutgoing ? Color.blue.opacity(0.16) : Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            if !isOutgoing { Spacer(minLength: 48) }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(chat: Chat(
            avatar: "avatar1",
            name: "Илья",
            lastMessage: "Увидимся вечером!",
            time: "12:45"
        ))
    }
}
