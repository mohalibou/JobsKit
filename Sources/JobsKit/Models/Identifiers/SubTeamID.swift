//
//  SubTeamID.swift
//  JobsKit
//

/// Identifies a sub-team, such as `subTeam-AF`.
///
/// Unique only within its team.
public struct SubTeamID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
