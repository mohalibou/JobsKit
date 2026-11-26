//
//  SearchRequestTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

struct SearchRequestTests {
    private func encode(_ query: JobQuery) throws -> [String: Any] {
        let data = try JSONEncoder().encode(SearchRequest(query, page: 1, locale: "en-us"))
        return try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    private func filters(_ query: JobQuery) throws -> [String: Any] {
        try #require(try encode(query)["filters"] as? [String: Any])
    }

    @Test func defaultQueryHasNoFilters() throws {
        #expect(try filters(JobQuery()).isEmpty)
    }

    @Test func alwaysSendsFormat() throws {
        let format = try #require(try encode(JobQuery())["format"] as? [String: Any])
        #expect(format.isEmpty)
    }

    @Test(arguments: [
        (Workplace.any, nil),
        (.remoteOnly, true),
        (.excludeRemote, false),
    ])
    func encodesWorkplace(workplace: Workplace, expected: Bool?) throws {
        #expect(try filters(JobQuery(workplace: workplace))["homeOffice"] as? Bool == expected)
    }

    @Test(arguments: [
        (JobsKit.SortOrder.relevance, "relevance"),
        (.newest, "newest"),
        (.teamAscending, "teamAsc"),
        (.teamDescending, "teamDesc"),
        (.locationAscending, "locationAsc"),
        (.locationDescending, "locationDesc"),
    ])
    func encodesSort(order: JobsKit.SortOrder, expected: String) throws {
        #expect(try encode(JobQuery(sort: order))["sort"] as? String == expected)
    }

    @Test func encodesLists() throws {
        let filters = try filters(JobQuery(
            anyKeywords: ["swift"],
            locations: [LocationID(rawValue: "postLocation-CUP")],
            products: [.siri],
            languages: [LanguageID(rawValue: "language-en_US")]
        ))

        #expect(filters["keywords"] as? [String] == ["swift"])
        #expect(filters["locations"] as? [String] == ["postLocation-CUP"])
        #expect(filters["products"] as? [String] == ["productsAndServices-SIRI"])
        #expect(filters["languages"] as? [String] == ["language-en_US"])
    }

    @Test func encodesTeams() throws {
        let query = JobQuery(teams: [.all(in: .design), TeamFilter.Hardware.architecture])
        #expect(try filters(query)["teams"] as? [[String: String]] == [
            ["team": "teamsAndSubTeams-DESGN"],
            ["team": "teamsAndSubTeams-HRDWR", "subTeam": "subTeam-ARCH"],
        ])
    }
}
