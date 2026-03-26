import Foundation

public struct NoteMember: Identifiable, Codable, Hashable, Sendable {
    public let id: EntityID   // userId

    public init(id: EntityID) {
        self.id = id
    }
}

public struct SharedNote: Identifiable, Codable, Hashable, Sendable {
    public let id: EntityID
    public let roomId: EntityID
    public var title: String?
    public var content: String
    public var members: [NoteMember]
    public var updatedAt: Date

    public init(
        id: EntityID,
        roomId: EntityID,
        title: String? = nil,
        content: String,
        members: [NoteMember],
        updatedAt: Date
    ) {
        self.id = id
        self.roomId = roomId
        self.title = title
        self.content = content
        self.members = members
        self.updatedAt = updatedAt
    }
}
