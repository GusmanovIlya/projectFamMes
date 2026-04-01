import Foundation

struct Chat: Identifiable, Hashable {
    let id: EntityID
    let avatar: String
    let name: String
    var lastMessage: String
    var time: String
}
