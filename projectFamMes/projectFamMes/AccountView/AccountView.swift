import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack() {
            Image("avatar1")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 200, height: 200)
                .overlay(Circle().stroke(Color.black, lineWidth: 4))
            Text("@GusmanovIlya")
                .font(.headline)
                .foregroundStyle(Color.secondary)
            Text("Ilya")
                .font(Font.largeTitle)
            Text("I am a swift developer")
        }
    }
}

#Preview {
    AccountView()
}
