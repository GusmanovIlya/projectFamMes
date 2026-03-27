import SwiftUI

struct ChatsHomeView: View {
    var body: some View {
        NavigationStack( root: {
            VStack(alignment: .leading, spacing: 8) {
                HStack() {
                    Image("avatar1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Илья")
                            .font(.headline)
                        Divider()
                        Text("Привет как дела?")
                    }
                }
                .padding(8)
                Spacer()
                
            }
            .navigationTitle("Чаты")
        })
    }
}

#Preview {
    ChatsHomeView()
}
