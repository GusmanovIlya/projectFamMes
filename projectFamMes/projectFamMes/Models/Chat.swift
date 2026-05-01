import Foundation

struct Chat: Identifiable, Hashable {
    let id: EntityID
    let avatar: String
    let name: String
    let username: String
    var lastMessage: String
    var time: String
}
