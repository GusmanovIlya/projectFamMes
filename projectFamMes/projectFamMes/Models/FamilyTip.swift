import Foundation

struct FamilyTip: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let text: String
    let imageURL: URL?
}
