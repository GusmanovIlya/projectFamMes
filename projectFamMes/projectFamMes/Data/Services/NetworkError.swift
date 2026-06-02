import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL"
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .badStatusCode(let code):
            return "Сервер вернул ошибку: \(code)"
        case .decodingFailed:
            return "Не удалось обработать данные сервера"
        }
    }
}
