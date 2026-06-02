import Foundation

final class RemoteFamilyTipService: FamilyTipService {
    private let session: URLSession

    private let russianTips = [
        "Запишите важную мысль сразу, чтобы не искать её потом в переписках.",
        "Создайте общую заметку для семейных дел: покупки, планы и важные даты будут в одном месте.",
        "Короткие заметки работают лучше длинных: одна мысль — одна заметка.",
        "Обновляйте общие заметки после обсуждения, чтобы у всех была актуальная информация.",
        "Используйте личные заметки для идей, которые пока не готовы отправлять в общий чат.",
        "Договоритесь с близкими о простых названиях заметок, чтобы быстрее находить нужное.",
        "Регулярно удаляйте устаревшие заметки, чтобы приложение оставалось аккуратным."
    ]

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchDailyTip() async throws -> FamilyTip {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=30") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }

        do {
            let photos = try JSONDecoder().decode([PicsumPhotoDTO].self, from: data)

            guard let photo = photos.randomElement(),
                  let imageURL = URL(string: photo.download_url) else {
                throw NetworkError.decodingFailed
            }

            return FamilyTip(
                id: Int(photo.id) ?? Int.random(in: 1...10_000),
                title: "Совет дня",
                text: russianTips.randomElement() ?? "Создавайте заметки, чтобы важная информация всегда была под рукой.",
                imageURL: imageURL
            )
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

private struct PicsumPhotoDTO: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
