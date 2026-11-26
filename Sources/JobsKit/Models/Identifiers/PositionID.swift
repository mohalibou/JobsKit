//
//  PositionID.swift
//  JobsKit
//

/// Identifies a position, such as `200696418`. Several postings can share one.
public struct PositionID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
