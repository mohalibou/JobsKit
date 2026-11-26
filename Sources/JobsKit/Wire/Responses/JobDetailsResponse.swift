//
//  JobDetailsResponse.swift
//  JobsKit
//

import Foundation

/// Response of `Endpoint.jobDetails`.
struct JobDetailsResponse: Decodable, Hashable, Sendable {
    let id: String
    let positionId: String
    let postingTitle: String
    
    let reqId: String?
    let jobNumber: String?
    let type: String?
    let transformedPostingTitle: String?
    
    let jobSummary: String?
    let description: String?
    let responsibilities: String?
    let minimumQualifications: String?
    let preferredQualifications: String?
    
    /// Extra sections for each location, such as pay and benefits.
    let postingFooters: [Footer]?
    
    /// Looks like `RETAIL` or `CORPORATE`.
    let jobType: String?
    
    /// Looks like `Standard`, `Intern`, or `Fixed`.
    let employmentType: String?
    
    let pipelineType: String?
    let lowJobTitle: String?
    let highJobTitle: String?
    let standardWeeklyHours: Double?
    let homeOffice: Bool?
    let managedPipelineRole: Bool?
    let roleLocationSelection: Bool?
    
    /// ISO 8601 with a numeric offset, such as `2026-09-18T20:30:17.449+00:00`.
    let postDateInGMT: String?
    
    let teamNames: [String]?
    let locations: [Location]?
    let selectedLocation: Location?
    let selectedLocale: String?
    let localeLanguages: [LocaleLanguage]?
    
    struct Location: Decodable, Hashable, Sendable {
        let id: String
        let name: String?
        let code: String?
        let city: String?
        let stateProvince: String?
        let metro: String?
        let region: String?
        let zipCode: String?
        let countryName: String?
        let countryID: String?
        let postLocationCountryID: String?
        let level: Int?
        let active: Bool?
        let showPayAndBenefits: Bool?
    }
    
    struct LocaleLanguage: Decodable, Hashable, Sendable {
        let code: String
        let name: String?
        let translation: String?
        let direction: String?
    }
    
    struct Footer: Decodable, Hashable, Sendable {
        let postLocationId: String
        
        /// Sections keyed by locale, such as `en_US`.
        let localizations: [String: [Section]]?
        
        struct Section: Decodable, Hashable, Sendable {
            let name: String?
            let label: String?
            
            /// May contain HTML.
            let content: String?
            let displayOrder: Int?
        }
    }
}

// MARK: - Mapping

extension JobDetails {
    init(_ response: JobDetailsResponse) {
        let isEvergreen = response.managedPipelineRole ?? false
        
        self.init(
            positionID: PositionID(rawValue: response.positionId),
            roleNumber: response.jobNumber?.nonEmpty,
            title: response.postingTitle,
            summary: response.jobSummary?.nonEmpty,
            description: response.description?.nonEmpty,
            responsibilities: response.responsibilities?.nonEmpty,
            minimumQualifications: response.minimumQualifications?.nonEmpty,
            preferredQualifications: response.preferredQualifications?.nonEmpty,
            postedAt: isEvergreen ? nil : response.postDateInGMT.flatMap(Date.init(appleTimestamp:)),
            isEvergreen: isEvergreen,
            isRemote: response.homeOffice ?? false,
            weeklyHours: response.standardWeeklyHours,
            employmentType: response.employmentType?.nonEmpty.map(EmploymentType.init),
            teamNames: response.teamNames ?? [],
            locations: (response.locations ?? []).map(Location.init),
            locationDetails: (response.postingFooters ?? []).map(LocationDetails.init)
        )
    }
}

extension JobDetails.Location {
    init(_ response: JobDetailsResponse.Location) {
        self.init(
            id: LocationID(rawValue: response.id),
            name: response.name?.nonEmpty,
            city: response.city?.nonEmpty,
            stateOrProvince: response.stateProvince?.nonEmpty,
            postalCode: response.zipCode?.nonEmpty,
            country: response.countryName?.nonEmpty,
            level: response.level.map(LocationLevel.init)
        )
    }
}

extension JobDetails.LocationDetails {
    init(_ response: JobDetailsResponse.Footer) {
        let sections = (response.localizations ?? [:]).mapValues { sections in
            sections
                .sorted { ($0.displayOrder ?? .max) < ($1.displayOrder ?? .max) }
                .compactMap { section -> JobDetails.Section? in
                    guard let content = section.content?.nonEmpty else { return nil }
                    return JobDetails.Section(title: section.name ?? "", content: content)
                }
        }
        
        self.init(
            locationID: LocationID(rawValue: response.postLocationId),
            sections: sections,
            payRange: sections
                .sorted { $0.key < $1.key }
                .flatMap(\.value)
                .lazy
                .compactMap { PayRange(text: $0.content) }
                .first
        )
    }
}
