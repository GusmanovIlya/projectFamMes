import SwiftUI

struct FamilyTipCardView: View {
    let vm: FamilyTipViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("propoganda viperr")
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14,
                        style: .continuous
                    )
                )

            Text("Совет дня")
                .font(.headline)

            textContent
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
        )
        .task {
            await vm.loadTipIfNeeded()
        }
    }

    @ViewBuilder
    private var textContent: some View {
        switch vm.state {
        case .loading:
            HStack(spacing: 8) {
                ProgressView()

                Text("Загружаем совет...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

        case .empty:
            Text("Совет пока недоступен")
                .font(.subheadline)
                .foregroundStyle(.secondary)

        case .content:
            if let tip = vm.tip {
                Text(tip.text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

        case .error(let message):
            VStack(alignment: .leading, spacing: 8) {
                Text("Не удалось загрузить совет")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Повторить") {
                    Task {
                        await vm.loadTip()
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
