//
//  CatalogResponse.swift
//  JobsKit
//

/// A product or a language.
struct CatalogItemResponse: Decodable, Hashable, Sendable {
    let id: String
    let code: String?
    let name: String?
    let displayName: String?
}

/// Response of `Endpoint.products`.
struct ProductsResponse: Decodable, Hashable, Sendable {
    let products: [CatalogItemResponse]
}

/// An element of the response of `Endpoint.teams`.
struct TeamResponse: Decodable, Hashable, Sendable {
    let id: String
    
    /// The team's name.
    let type: String?
    
    let teams: [SubTeamResponse]
}

/// A sub-team, also an element of the response of `Endpoint.teamsMatching`.
struct SubTeamResponse: Decodable, Hashable, Sendable {
    let id: String
    let code: String?
    let name: String?
    let displayName: String?
    let teamID: String
    let teamName: String?
    let teamCode: String?
}

/// Response of `Endpoint.resolveFilters`.
struct ResolvedFiltersResponse: Decodable, Hashable, Sendable {
    let locations: [LocationResponse]?
    let products: [CatalogItemResponse]?
    let languages: [CatalogItemResponse]?
}

// MARK: - Mapping

extension Product {
    init(_ response: CatalogItemResponse) {
        self.init(
            id: ProductID(rawValue: response.id),
            name: response.name?.nonEmpty ?? response.id
        )
    }
}

extension Language {
    init(_ response: CatalogItemResponse) {
        self.init(
            id: LanguageID(rawValue: response.id),
            name: response.name?.nonEmpty ?? response.id
        )
    }
}

extension Team {
    init(_ response: TeamResponse) {
        self.init(
            id: TeamID(rawValue: response.id),
            name: response.type?.nonEmpty ?? response.id,
            subTeams: response.teams.map(SubTeam.init)
        )
    }
}

extension SubTeam {
    init(_ response: SubTeamResponse) {
        self.init(
            id: SubTeamID(rawValue: response.id),
            teamID: TeamID(rawValue: response.teamID),
            name: response.name?.nonEmpty ?? response.id
        )
    }
}
