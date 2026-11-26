//
//  TeamFilter.swift
//  JobsKit
//

/// Matches jobs in a team, or in one of its sub-teams.
public enum TeamFilter: Hashable, Codable, Sendable {
    case all(in: TeamID)
    case subTeam(SubTeamID, in: TeamID)
}
