//
//  ResolveFiltersRequest.swift
//  JobsKit
//

/// Body of `Endpoint.resolveFilters`.
struct ResolveFiltersRequest: Encodable, Hashable, Sendable {
    var filters: Filters
    
    struct Filters: Encodable, Hashable, Sendable {
        var locations: [String]?
        var products: [String]?
        var languages: [String]?
    }
}
