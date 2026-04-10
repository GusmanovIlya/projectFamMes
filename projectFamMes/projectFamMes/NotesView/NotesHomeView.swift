import SwiftUI

struct NotesHomeView: View {
    @State var vm: NotesViewModel

    @State private var showCreatePersonal = false
    @State private var showCreateShared = false

    @State private var editingPersonalNote: PersonalNote?
    @State private var editingSharedNote: SharedNote?

    var body: some View {
        NavigationStack {
            List {
                if !vm.personalNotes.isEmpty {
                    Section("Личные") {
                        ForEach(vm.personalNotes) { note in
                            NoteCardView(
                                title: note.title ?? "Без названия",
                                content: note.content,
                                updatedAt: note.updatedAt,
                                membersCount: nil
                            )
                            .overlay {
                                NavigationLink(destination: NoteView(note: note)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await vm.deletePersonalNote(id: note.id)
                                    }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }

                                Button {
                                    editingPersonalNote = note
                                } label: {
                                    Label("Изменить", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }

                if !vm.sharedNotes.isEmpty {
                    Section("Общие") {
                        ForEach(vm.sharedNotes) { note in
                            NoteCardView(
                                title: note.title ?? "Без названия",
                                content: note.content,
                                updatedAt: note.updatedAt,
                                membersCount: note.members.count
                            )
                            .overlay {
                                NavigationLink(destination: SharedNoteView(note: note)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await vm.deleteSharedNote(id: note.id)
                                    }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }

                                Button {
                                    editingSharedNote = note
                                } label: {
                                    Label("Изменить", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }

                if vm.personalNotes.isEmpty && vm.sharedNotes.isEmpty {
                    ContentUnavailableView(
                        "Нет заметок",
                        systemImage: "note.text",
                        description: Text("Создай первую личную или общую заметку")
                    )
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Заметки")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showCreatePersonal = true
                        } label: {
                            Label("Личная заметка", systemImage: "person")
                        }

                        Button {
                            showCreateShared = true
                        } label: {
                            Label("Общая заметка", systemImage: "person.2")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreatePersonal) {
                NotesEditView(vm: vm)
            }
            .sheet(isPresented: $showCreateShared) {
                SharedNotesEditView(vm: vm)
            }
            .sheet(item: $editingPersonalNote) { note in
                NotesEditView(vm: vm, note: note)
            }
            .sheet(item: $editingSharedNote) { note in
                SharedNotesEditView(vm: vm, note: note)
            }
        }
        .task {
            await vm.loadPersonalNotes()
            await vm.loadSharedNotes()
        }
    }
}


struct NoteCardView: View {
    let title: String
    let content: String
    let updatedAt: Date
    let membersCount: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .lineLimit(1)

            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            HStack {
                Text(updatedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if let membersCount {
                    Label("\(membersCount)", systemImage: "person.2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
