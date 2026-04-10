import SwiftUI

struct RootView: View {
    private let notesRepository: MockNotesRepository
    @State private var notesVM: NotesViewModel

    init() {
        let repo = MockNotesRepository()
        self.notesRepository = repo
        _notesVM = State(initialValue: NotesViewModel(repository: repo))
    }

    var body: some View {
        TabView {
            NavigationStack {
                NotesHomeView(vm: notesVM)
            }
            .tabItem { Label("Заметки", systemImage: "note.text") }

            NavigationStack {
                ChatsHomeView(notesVM: notesVM)
            }
            .tabItem { Label("Чаты", systemImage: "bubble.left.and.bubble.right") }

            NavigationStack {
                AccountView()
            }
            .tabItem { Label("Аккаунт", systemImage: "person.circle") }
        }
        .task {
            await notesVM.reloadAll()
        }
    }
}

#Preview {
    RootView()
}
