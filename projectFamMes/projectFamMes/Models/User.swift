import Foundation

public struct User: Identifiable, Codable, Hashable, Sendable {
    public let id: EntityID
    public var name: String
    public var username: String
    public var avatarURL: URL?
    public var friendIds: [EntityID]

    public init(
        id: EntityID,
        name: String,
        username: String,
        avatarURL: URL? = nil,
        friendIds: [EntityID] = []
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.avatarURL = avatarURL
        self.friendIds = friendIds
    }
}

public struct UserSummary: Identifiable, Codable, Hashable, Sendable {
    public let id: EntityID
    public var name: String
    public var username: String
    public var avatarURL: URL?

    public init(id: EntityID, name: String, username: String, avatarURL: URL? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.avatarURL = avatarURL
    }
}
