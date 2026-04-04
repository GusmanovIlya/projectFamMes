import SwiftUI

struct SharedNoteView: View {
    let note: SharedNote

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(note.title ?? "Без названия")
                .font(.title2)
                .bold()

            Text(note.content)

            Text("Участников: \(note.members.count)")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Общая заметка")
    }
}
