import SwiftUI

struct RootView: View {
    private let notesRepository: MockNotesRepository
    private let chatRepository: MockChatRepository

    @State private var notesVM: NotesViewModel

    init() {
        let notesRepo = MockNotesRepository()
        let chatRepo = MockChatRepository()

        self.notesRepository = notesRepo
        self.chatRepository = chatRepo
        _notesVM = State(initialValue: NotesViewModel(repository: notesRepo))
    }

    var body: some View {
        TabView {
            NotesHomeView(vm: notesVM, chatRepository: chatRepository)
                .tabItem {
                    Label("Заметки", systemImage: "note.text")
                }

            ChatsHomeView(repo: chatRepository)
                .tabItem {
                    Label("Чаты", systemImage: "bubble.left.and.bubble.right")
                }

            NavigationStack {
                AccountView()
            }
            .tabItem {
                Label("Аккаунт", systemImage: "person.circle")
            }
        }
        .task {
            await notesVM.reloadAll()
        }
    }
}

#Preview {
    RootView()
}
