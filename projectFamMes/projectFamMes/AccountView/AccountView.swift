import SwiftUI

struct AccountView: View {
    private let avatarSize: CGFloat = 200

    var body: some View {
        VStack(spacing: 12) {
            Image("avatar1")
                .resizable()
                .scaledToFill()
                .frame(width: avatarSize, height: avatarSize)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(.black, lineWidth: 4)
                }
                .shadow(color: .black.opacity(0.2), radius: 10, y: 4)

            VStack(spacing: 4) {
                Text("Ilya")
                    .font(.title)
                    .fontWeight(.bold)

                Text("@GusmanovIlya")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("iOS / Swift Developer")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    AccountView()
}
