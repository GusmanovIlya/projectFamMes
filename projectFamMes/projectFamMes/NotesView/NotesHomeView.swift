import SwiftUI

struct NotesHomeView: View {
    @State private var vm = NotesViewModel(repo: MockNotesRepository())
    @State private var showCreate = false
    @State private var editingNote: PersonalNote?

    var body: some View {
        NavigationStack {
                    List {
                        ForEach(vm.notes) { note in
                            NoteCardView(
                        title: note.title ?? "Без названия",
                        content: note.content,
                        updatedAt: note.updatedAt
                    )
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingNote = note
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task { await vm.delete(id: note.id) }
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }

                        Button {
                            editingNote = note
                        } label: {
                            Label("Изменить", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Заметки")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreate = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task {
            await vm.load()
        }
    }
}

struct NoteCardView: View {
    let title: String
    let content: String
    let updatedAt: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .lineLimit(1)

            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            Text(updatedAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    NotesHomeView()
}
