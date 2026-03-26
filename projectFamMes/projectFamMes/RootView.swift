import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { NotesHomeView() }
                .tabItem { Label("Заметки", systemImage: "note.text") }

            NavigationStack { ChatsHomeView() }
                .tabItem { Label("Чаты", systemImage: "bubble.left.and.bubble.right") }

            NavigationStack { AccountView() }
                .tabItem { Label("Аккаунт", systemImage: "person.circle") }
        }
    }
}

#Preview {
    RootView()
}
