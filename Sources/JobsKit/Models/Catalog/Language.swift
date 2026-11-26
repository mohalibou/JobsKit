//
//  Language.swift
//  JobsKit
//

/// A language that jobs can require.
public struct Language: Identifiable, Hashable, Codable, Sendable {
    public let id: LanguageID
    public let name: String

    public init(id: LanguageID, name: String) {
        self.id = id
        self.name = name
    }
}
