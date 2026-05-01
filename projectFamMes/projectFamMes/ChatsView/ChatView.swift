import SwiftUI

struct ChatView: View {
    let chat: Chat
    @State var vm: ChatViewModel
    let chatRepository: ChatRepository

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.messages) { message in
                        MessageBubble(
                            text: message.text,
                            time: message.createdAt.formatted(date: .omitted, time: .shortened),
                            isOutgoing: vm.isOutgoing(message)
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
        .task {
            await vm.load()
        }
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Сообщение", text: $vm.draft, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button {
                Task {
                    await vm.sendMessage()
                }
            } label: {
                Image(systemName: "arrow.up")
                    .font(.headline)
                    .frame(width: 44, height: 30)
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
    let chatRepo = MockChatRepository()

    NavigationStack {
        ChatView(
            chat: Chat(
                id: "room_ilya",
                avatar: "avatar1",
                name: "Илья",
                username: "ilya",
                lastMessage: "Увидимся вечером!",
                time: "12:45"
            ),
            vm: ChatViewModel(roomId: "room_ilya", repo: chatRepo),
            chatRepository: chatRepo
        )
    }
}
