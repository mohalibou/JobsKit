//
//  JobQuery.swift
//  JobsKit
//

/// Describes which jobs to search for.
public struct JobQuery: Hashable, Codable, Sendable {
    public var text: String
    
    /// Matches jobs with any of the keywords.
    public var anyKeywords: [String]
    
    public var locations: [LocationID]
    public var teams: [TeamFilter]
    public var products: [ProductID]
    public var languages: [LanguageID]
    public var workplace: Workplace
    public var sort: SortOrder
    
    public init(
        text: String = "",
        anyKeywords: [String] = [],
        locations: [LocationID] = [],
        teams: [TeamFilter] = [],
        products: [ProductID] = [],
        languages: [LanguageID] = [],
        workplace: Workplace = .any,
        sort: SortOrder = .newest
    ) {
        self.text = text
        self.anyKeywords = anyKeywords
        self.locations = locations
        self.teams = teams
        self.products = products
        self.languages = languages
        self.workplace = workplace
        self.sort = sort
    }
}
