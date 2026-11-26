//
//  Team.swift
//  JobsKit
//

/// A team and its sub-teams.
public struct Team: Identifiable, Hashable, Codable, Sendable {
    public let id: TeamID
    public let name: String
    public let subTeams: [SubTeam]

    public init(
        id: TeamID,
        name: String,
        subTeams: [SubTeam] = []
    ) {
        self.id = id
        self.name = name
        self.subTeams = subTeams
    }
}

public struct SubTeam: Hashable, Codable, Sendable {
    /// Unique only within its team.
    public let id: SubTeamID
    public let teamID: TeamID
    public let name: String

    public init(
        id: SubTeamID,
        teamID: TeamID,
        name: String
    ) {
        self.id = id
        self.teamID = teamID
        self.name = name
    }
    
    /// Matches jobs in the sub-team.
    public var filter: TeamFilter {
        .subTeam(id, in: teamID)
    }
}
