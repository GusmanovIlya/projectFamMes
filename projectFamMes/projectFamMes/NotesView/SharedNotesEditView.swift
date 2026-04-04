import SwiftUI

struct SharedNotesEditView: View {
    let vm: NotesViewModel
    var note: SharedNote?

    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var content = ""

    init(vm: NotesViewModel, note: SharedNote? = nil) {
        self.vm = vm
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Заголовок", text: $title)

                TextEditor(text: $content)
                    .frame(minHeight: 160)
            }
            .navigationTitle(note == nil ? "Новая общая" : "Редактировать")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        Task {
                            let members = note?.members ?? [NoteMember(id: UUID().uuidString)]

                            if let note {
                                await vm.updateSharedNote(
                                    id: note.id,
                                    title: title.isEmpty ? nil : title,
                                    content: content,
                                    members: members
                                )
                            } else {
                                await vm.createSharedNote(
                                    roomId: UUID().uuidString,
                                    title: title.isEmpty ? nil : title,
                                    content: content,
                                    members: members
                                )
                            }

                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
