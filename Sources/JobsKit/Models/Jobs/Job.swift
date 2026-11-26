//
//  Job.swift
//  JobsKit
//

import Foundation

/// A job in a page of search results.
public struct Job: Identifiable, Hashable, Codable, Sendable {
    public let id: JobID
    public let positionID: PositionID
    public let title: String
    public let summary: String?
    
    /// `nil` for evergreen roles, which have no meaningful posting date.
    public let postedAt: Date?
    
    /// Whether the role continuously accepts candidates.
    public let isEvergreen: Bool
    
    public let isRemote: Bool
    public let weeklyHours: Double?
    public let team: Team?
    public let locations: [Location]

    public init(
        id: JobID,
        positionID: PositionID,
        title: String,
        summary: String? = nil,
        postedAt: Date? = nil,
        isEvergreen: Bool = false,
        isRemote: Bool = false,
        weeklyHours: Double? = nil,
        team: Team? = nil,
        locations: [Location] = []
    ) {
        self.id = id
        self.positionID = positionID
        self.title = title
        self.summary = summary
        self.postedAt = postedAt
        self.isEvergreen = isEvergreen
        self.isRemote = isRemote
        self.weeklyHours = weeklyHours
        self.team = team
        self.locations = locations
    }
    
    public struct Team: Identifiable, Hashable, Codable, Sendable {
        public let id: TeamID
        public let name: String?

        public init(id: TeamID, name: String? = nil) {
            self.id = id
            self.name = name
        }
    }
    
    public struct Location: Identifiable, Hashable, Codable, Sendable {
        public let id: LocationID
        public let name: String?
        public let country: String?
        public let level: LocationLevel?

        public init(
            id: LocationID,
            name: String? = nil,
            country: String? = nil,
            level: LocationLevel? = nil
        ) {
            self.id = id
            self.name = name
            self.country = country
            self.level = level
        }
    }
}
