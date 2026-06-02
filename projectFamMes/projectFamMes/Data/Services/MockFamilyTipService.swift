import Foundation

final class MockFamilyTipService: FamilyTipService {
    private let result: Result<FamilyTip, Error>?

    private let tips = [
        "Запишите важную мысль сразу, чтобы не искать её потом в переписках.",
        "Создайте общую заметку для семейных дел: покупки, планы и важные даты будут в одном месте.",
        "Короткие заметки работают лучше длинных: одна мысль — одна заметка.",
        "Обновляйте общие заметки после обсуждения, чтобы у всех была актуальная информация."
    ]

    init(result: Result<FamilyTip, Error>? = nil) {
        self.result = result
    }

    func fetchDailyTip() async throws -> FamilyTip {
        try? await Task.sleep(nanoseconds: 400_000_000)

        if let result {
            return try result.get()
        }

        return FamilyTip(
            id: Int.random(in: 1...10_000),
            title: "Совет дня",
            text: tips.randomElement() ?? "Создавайте заметки, чтобы важное не терялось.",
            imageURL: URL(string: "https://picsum.photos/seed/fammes-mock/600/300")
        )
    }
}
