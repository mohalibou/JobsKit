//
//  LanguageID.swift
//  JobsKit
//

/// Identifies a language, such as `language-en_US`.
public struct LanguageID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
