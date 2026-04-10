import SwiftUI

struct ChatsHomeView: View {
    private let repo: MockChatRepository
    @State private var vm: ChatsHomeViewModel
    let notesVM: NotesViewModel

    init(notesVM: NotesViewModel) {
        let repo = MockChatRepository()
        self.repo = repo
        self.notesVM = notesVM
        _vm = State(initialValue: ChatsHomeViewModel(repo: repo))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(vm.chats) { chat in
                        NavigationLink {
                            ChatView(
                                chat: chat,
                                vm: ChatViewModel(roomId: chat.id, repo: repo),
                                notesVM: notesVM
                            )
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
        .task {
            await vm.load()
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
    let notesVM = NotesViewModel(repository: MockNotesRepository())
    ChatsHomeView(notesVM: notesVM)
}
