import SwiftUI
import SwiftData
import UIKit

struct AccountView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    private let avatarSize: CGFloat = 150

    @State private var isEditingBio = false
    @State private var bioDraft = ""
    @State private var showLogoutConfirmation = false

    @State private var showImagePicker = false
    @State private var selectedAvatarImage: UIImage?

    @State private var tipVM: FamilyTipViewModel

    init(tipService: any FamilyTipService = RemoteFamilyTipService()) {
        _tipVM = State(
            initialValue: FamilyTipViewModel(service: tipService)
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                if let user = authViewModel.currentUser {
                    profileHeader(user: user)

                    FamilyTipCardView(vm: tipVM)
                        .padding(.horizontal, 20)

                    logoutButton
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                } else {
                    ContentUnavailableView(
                        "Пользователь не найден",
                        systemImage: "person.crop.circle.badge.exclamationmark",
                        description: Text("Попробуйте войти в аккаунт снова")
                    )
                    .padding(.top, 80)
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Аккаунт")
        .sheet(isPresented: $isEditingBio) {
            editBioView
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedAvatarImage)
        }
    }

    private func profileHeader(user: User) -> some View {
        VStack(spacing: 12) {
            Button {
                showImagePicker = true
            } label: {
                avatarImage(avatarName: user.avatarName)
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.black, lineWidth: 3)
                    }
                    .shadow(
                        color: Color.black.opacity(0.16),
                        radius: 8,
                        y: 4
                    )
            }
            .buttonStyle(.plain)

            Text("Нажми на фото, чтобы изменить")
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(spacing: 5) {
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text("@\(user.username)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(user.bio)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button {
                bioDraft = user.bio
                isEditingBio = true
            } label: {
                Label("Изменить био", systemImage: "pencil")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }

    private var logoutButton: some View {
        Button(role: .destructive) {
            showLogoutConfirmation = true
        } label: {
            Text("Выйти из аккаунта")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.12))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14,
                        style: .continuous
                    )
                )
        }
        .confirmationDialog(
            "Вы уверены, что хотите выйти из аккаунта?",
            isPresented: $showLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Выйти", role: .destructive) {
                authViewModel.logout()
            }

            Button("Отмена", role: .cancel) { }
        }
    }

    private var editBioView: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Расскажи немного о себе")
                    .font(.headline)

                TextEditor(text: $bioDraft)
                    .frame(minHeight: 160)
                    .padding(8)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                    )

                Spacer()
            }
            .padding(20)
            .navigationTitle("Био")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        isEditingBio = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        authViewModel.updateBio(bioDraft)
                        isEditingBio = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func avatarImage(avatarName: String) -> some View {
        if let selectedAvatarImage {
            Image(uiImage: selectedAvatarImage)
                .resizable()
                .scaledToFill()
        } else {
            Image(avatarName)
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: UserEntity.self,
        AppSessionEntity.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    AccountView(tipService: MockFamilyTipService())
        .modelContainer(container)
        .environment(AuthViewModel(modelContext: container.mainContext))
}
