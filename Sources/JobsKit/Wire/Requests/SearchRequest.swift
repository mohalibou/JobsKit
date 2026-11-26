//
//  SearchRequest.swift
//  JobsKit
//

/// Body of `Endpoint.search`.
struct SearchRequest: Encodable, Hashable, Sendable {
    var query = ""
    var filters = SearchFilters()
    var page = 1
    
    /// Looks like `en-us`.
    var locale = "en-us"
    var sort = Sort.newest
    
    /// Must be sent, even if empty. An empty format returns ISO 8601 dates.
    let format = Format()
    
    enum Sort: String, Encodable, Sendable {
        case relevance
        case newest
        case teamAsc
        case teamDesc
        case locationAsc
        case locationDesc
    }
    
    struct Format: Encodable, Hashable, Sendable {}
}

struct SearchFilters: Encodable, Hashable, Sendable {
    /// Matches jobs with any of the keywords.
    var keywords: [String]?
    
    /// `true` returns only remote jobs, `false` excludes them, and `nil` returns both.
    var homeOffice: Bool?
    
    var locations: [String]?
    var teams: [Team]?
    var products: [String]?
    var languages: [String]?
    
    struct Team: Encodable, Hashable, Sendable {
        /// Looks like `teamsAndSubTeams-SFTWR`.
        var team: String
        
        /// Looks like `subTeam-AF`. `nil` matches the whole team.
        var subTeam: String?
    }
}

// MARK: - Mapping

extension SearchRequest {
    /// `locale` looks like `en-us`.
    init(_ query: JobQuery, page: Int, locale: String) {
        self.init(
            query: query.text,
            filters: SearchFilters(query),
            page: page,
            locale: locale,
            sort: Sort(query.sort)
        )
    }
}

extension SearchRequest.Sort {
    init(_ order: SortOrder) {
        self = switch order {
            case .relevance:          .relevance
            case .newest:             .newest
            case .teamAscending:      .teamAsc
            case .teamDescending:     .teamDesc
            case .locationAscending:  .locationAsc
            case .locationDescending: .locationDesc
        }
    }
}

extension SearchFilters {
    init(_ query: JobQuery) {
        self.init(
            keywords: query.anyKeywords.nonEmpty,
            homeOffice: query.workplace.homeOffice,
            locations: query.locations.map(\.rawValue).nonEmpty,
            teams: query.teams.map(Team.init).nonEmpty,
            products: query.products.map(\.rawValue).nonEmpty,
            languages: query.languages.map(\.rawValue).nonEmpty
        )
    }
}

extension SearchFilters.Team {
    init(_ filter: TeamFilter) {
        switch filter {
            case .all(let team):
                self.init(team: team.rawValue)
            case .subTeam(let subTeam, let team):
                self.init(team: team.rawValue, subTeam: subTeam.rawValue)
        }
    }
}

private extension Workplace {
    var homeOffice: Bool? {
        switch self {
            case .any:           nil
            case .remoteOnly:    true
            case .excludeRemote: false
        }
    }
}

private extension Array {
    var nonEmpty: Self? {
        isEmpty ? nil : self
    }
}
