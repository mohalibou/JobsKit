//
//  SearchResponse.swift
//  JobsKit
//

import Foundation

/// Response of `Endpoint.search`.
struct SearchResponse: Decodable, Hashable, Sendable {
    let searchResults: [JobPostingResponse]
    let totalRecords: Int
}

struct JobPostingResponse: Decodable, Hashable, Sendable {
    let id: String
    let positionId: String
    let postingTitle: String
    
    let reqId: String?
    let jobPositionId: String?
    let type: String?
    let transformedPostingTitle: String?
    let jobSummary: String?
    
    /// ISO 8601. Fractional seconds vary from three to nine digits.
    ///
    /// Evergreen roles can report the time of the request.
    let postDateInGMT: String?
    
    let standardWeeklyHours: Double?
    let homeOffice: Bool?
    let isMultiLocation: Bool?
    let managedPipelineRole: Bool?
    let postExternal: Bool?
    
    let team: Team?
    let locations: [Location]?
    
    struct Team: Decodable, Hashable, Sendable {
        let teamID: String
        let teamName: String?
        let teamCode: String?
    }
    
    /// Unknown values in a location are empty strings.
    struct Location: Decodable, Hashable, Sendable {
        let postLocationId: String
        let name: String?
        let city: String?
        let stateProvince: String?
        let metro: String?
        let region: String?
        let countryName: String?
        let countryID: String?
        let level: Int?
    }
}

// MARK: - Mapping

extension JobPage {
    init(_ response: SearchResponse, number: Int) {
        self.init(
            jobs: response.searchResults.map(Job.init),
            totalCount: response.totalRecords,
            number: number
        )
    }
}

extension Job {
    init(_ response: JobPostingResponse) {
        let isEvergreen = response.managedPipelineRole ?? false
        
        self.init(
            id: JobID(rawValue: response.id),
            positionID: PositionID(rawValue: response.positionId),
            title: response.postingTitle,
            summary: response.jobSummary?.nonEmpty,
            postedAt: isEvergreen ? nil : response.postDateInGMT.flatMap(Date.init(appleTimestamp:)),
            isEvergreen: isEvergreen,
            isRemote: response.homeOffice ?? false,
            weeklyHours: response.standardWeeklyHours,
            team: response.team.map {
                Team(id: TeamID(rawValue: $0.teamID), name: $0.teamName?.nonEmpty)
            },
            locations: (response.locations ?? []).map {
                Location(
                    id: LocationID(rawValue: $0.postLocationId),
                    name: $0.name?.nonEmpty,
                    country: $0.countryName?.nonEmpty,
                    level: $0.level.map(LocationLevel.init)
                )
            }
        )
    }
}
