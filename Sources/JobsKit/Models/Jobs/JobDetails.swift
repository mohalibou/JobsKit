//
//  JobDetails.swift
//  JobsKit
//

import Foundation

/// The full details of a posting.
public struct JobDetails: Hashable, Codable, Sendable {
    public let positionID: PositionID
    
    /// Apple's public number for the role, such as `200696418-3337`.
    public let roleNumber: String?
    
    public let title: String
    public let summary: String?
    
    // May contain HTML or line breaks.
    public let description: String?
    public let responsibilities: String?
    public let minimumQualifications: String?
    public let preferredQualifications: String?
    
    /// `nil` for evergreen roles, which have no meaningful posting date.
    public let postedAt: Date?
    
    /// Whether the role continuously accepts candidates.
    public let isEvergreen: Bool
    
    public let isRemote: Bool
    public let weeklyHours: Double?
    public let employmentType: EmploymentType?
    public let teamNames: [String]
    public let locations: [Location]
    
    /// Extra sections, such as pay and benefits, for each location.
    public let locationDetails: [LocationDetails]

    public init(
        positionID: PositionID,
        roleNumber: String? = nil,
        title: String,
        summary: String? = nil,
        description: String? = nil,
        responsibilities: String? = nil,
        minimumQualifications: String? = nil,
        preferredQualifications: String? = nil,
        postedAt: Date? = nil,
        isEvergreen: Bool = false,
        isRemote: Bool = false,
        weeklyHours: Double? = nil,
        employmentType: EmploymentType? = nil,
        teamNames: [String] = [],
        locations: [Location] = [],
        locationDetails: [LocationDetails] = []
    ) {
        self.positionID = positionID
        self.roleNumber = roleNumber
        self.title = title
        self.summary = summary
        self.description = description
        self.responsibilities = responsibilities
        self.minimumQualifications = minimumQualifications
        self.preferredQualifications = preferredQualifications
        self.postedAt = postedAt
        self.isEvergreen = isEvergreen
        self.isRemote = isRemote
        self.weeklyHours = weeklyHours
        self.employmentType = employmentType
        self.teamNames = teamNames
        self.locations = locations
        self.locationDetails = locationDetails
    }
}

// MARK: - Supporting Types

extension JobDetails {
    
    public struct EmploymentType: RawRepresentable, Hashable, Codable, Sendable {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static let standard = EmploymentType(rawValue: "Standard")
        public static let intern = EmploymentType(rawValue: "Intern")
        public static let fixed = EmploymentType(rawValue: "Fixed")
    }
    
    public struct Location: Identifiable, Hashable, Codable, Sendable {
        public let id: LocationID
        public let name: String?
        public let city: String?
        public let stateOrProvince: String?
        public let postalCode: String?
        public let country: String?
        public let level: LocationLevel?

        public init(
            id: LocationID,
            name: String? = nil,
            city: String? = nil,
            stateOrProvince: String? = nil,
            postalCode: String? = nil,
            country: String? = nil,
            level: LocationLevel? = nil
        ) {
            self.id = id
            self.name = name
            self.city = city
            self.stateOrProvince = stateOrProvince
            self.postalCode = postalCode
            self.country = country
            self.level = level
        }
    }
    
    public struct LocationDetails: Hashable, Codable, Sendable {
        public let locationID: LocationID
        
        /// Sections in display order, keyed by locale, such as `en_US`.
        public let sections: [String: [Section]]
        
        /// The pay stated in the sections, if it could be read from their text.
        public let payRange: PayRange?

        public init(
            locationID: LocationID,
            sections: [String: [Section]] = [:],
            payRange: PayRange? = nil
        ) {
            self.locationID = locationID
            self.sections = sections
            self.payRange = payRange
        }
    }
    
    public struct Section: Hashable, Codable, Sendable {
        public let title: String
        
        /// May contain HTML.
        public let content: String

        public init(title: String, content: String) {
            self.title = title
            self.content = content
        }
    }
}
