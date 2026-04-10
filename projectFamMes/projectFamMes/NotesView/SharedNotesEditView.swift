import SwiftUI

struct SharedNotesEditView: View {
    @Environment(\.dismiss) private var dismiss

    let vm: NotesViewModel
    let note: SharedNote?

    let presetRoomId: EntityID?
    let presetMembers: [NoteMember]
    let presetTitle: String?

    @State private var title: String
    @State private var content: String

    init(
        vm: NotesViewModel,
        note: SharedNote? = nil,
        presetRoomId: EntityID? = nil,
        presetMembers: [NoteMember] = [],
        presetTitle: String? = nil
    ) {
        self.vm = vm
        self.note = note
        self.presetRoomId = presetRoomId
        self.presetMembers = presetMembers
        self.presetTitle = presetTitle

        _title = State(initialValue: note?.title ?? presetTitle ?? "")
        _content = State(initialValue: note?.content ?? "")
    }

    private var displayMembers: [NoteMember] {
        if let note {
            return note.members
        }
        return presetMembers
    }

    private var participantsText: String {
        let names = displayMembers.map(\.name).filter { !$0.isEmpty }
        return names.isEmpty ? "Участники не указаны" : names.joined(separator: ", ")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Участники") {
                    Text(participantsText)
                        .foregroundStyle(.primary)
                }

                Section("Заголовок") {
                    TextField("Введите заголовок", text: $title)
                }

                Section("Текст") {
                    TextEditor(text: $content)
                        .frame(minHeight: 220)
                }
            }
            .navigationTitle(note == nil ? "Новая общая" : "Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        Task {
                            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                            let finalTitle = trimmedTitle.isEmpty ? nil : trimmedTitle

                            if let note {
                                await vm.updateSharedNote(
                                    id: note.id,
                                    title: finalTitle,
                                    content: content,
                                    members: note.members
                                )
                            } else {
                                let roomId = presetRoomId ?? UUID().uuidString
                                let members = presetMembers.isEmpty
                                    ? [NoteMember(id: "me", name: "Вы")]
                                    : presetMembers

                                await vm.createSharedNote(
                                    roomId: roomId,
                                    title: finalTitle,
                                    content: content,
                                    members: members
                                )
                            }

                            dismiss()
                        }
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
