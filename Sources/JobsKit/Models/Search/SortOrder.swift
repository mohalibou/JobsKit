//
//  SortOrder.swift
//  JobsKit
//

/// The order of search results.
public enum SortOrder: String, Hashable, Codable, CaseIterable, Sendable {
    case relevance
    case newest
    case teamAscending
    case teamDescending
    case locationAscending
    case locationDescending
}
