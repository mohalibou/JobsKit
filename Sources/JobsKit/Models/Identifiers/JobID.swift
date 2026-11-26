//
//  JobID.swift
//  JobsKit
//

/// Identifies a posting, such as `200696418-3337` or `PIPE-114438158`.
public struct JobID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
