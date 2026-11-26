//
//  EndpointTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct EndpointTests {
    let baseURL: URL

    init() throws {
        baseURL = try #require(URL(string: "https://example.com/api/v1"))
    }

    @Test(arguments: [
        (Endpoint.search, "POST", "/search"),
        (.jobDetails(id: "1"), "GET", "/jobDetails/1?locale=en-gb"),
        (.jobTitles, "POST", "/rolesearch"),
        (.titleSuggestions(term: "swift"), "GET", "/quickfind/swift"),
        (.locations(matching: "cup"), "GET", "/refData/postlocation?input=cup"),
        (
            .locationsInCountry(matching: "cup", countryID: "postLocation-USA"),
            "GET",
            "/refData/postLocationTypeAhead?input=cup&countryId=postLocation-USA&locale=en_UK"
        ),
        (.expandLocations, "POST", "/expandResults"),
        (
            .stores(jobID: "1", search: .location(id: "postLocation-CUP")),
            "GET",
            "/storeLocations?jobId=1&fieldValue=postLocation-CUP"
        ),
        (
            .stores(jobID: "1", search: .zipCode("95014", miles: 25)),
            "GET",
            "/storeLocations?jobId=1&searchField=zipCode&fieldValue=95014&milesRange=25"
        ),
        (
            .storeBenefits(jobID: "1", locationID: "postLocation-CUP"),
            "GET",
            "/storeBenefits?jobId=1&postLocation=postLocation-CUP&locale=en_UK"
        ),
        (.products, "GET", "/refData/search"),
        (.teams, "GET", "/refData/teamsofinterest"),
        (.teamsMatching("soft"), "GET", "/refData/teamsByInput?input=soft"),
        (.languagesMatching("en"), "GET", "/refData/languagesByInput?input=en"),
        (.resolveFilters, "POST", "/getRefDataById"),
    ])
    func buildsMethodAndURL(endpoint: Endpoint, method: String, path: String) throws {
        let request = try endpoint.urlRequest(baseURL: baseURL, locale: .enGB)
        #expect(request.httpMethod == method)
        #expect(request.url?.absoluteString == "https://example.com/api/v1" + path)
    }

    @Test func escapesSlashInPath() throws {
        let request = try Endpoint.titleSuggestions(term: "UI/UX")
            .urlRequest(baseURL: baseURL, locale: .enUS)
        #expect(request.url?.absoluteString.hasSuffix("/quickfind/UI%2FUX") == true)
    }

    @Test func escapesQuery() throws {
        let request = try Endpoint.languagesMatching("C++ &é")
            .urlRequest(baseURL: baseURL, locale: .enUS)
        #expect(request.url?.absoluteString.hasSuffix("?input=C%2B%2B%20%26%C3%A9") == true)
    }

    @Test func acceptsTrailingSlashInBaseURL() throws {
        let baseURL = try #require(URL(string: "https://example.com/api/v1/"))
        let request = try Endpoint.products.urlRequest(baseURL: baseURL, locale: .enUS)
        #expect(request.url?.absoluteString == "https://example.com/api/v1/refData/search")
    }

    @Test func sendsLocaleHeader() throws {
        let request = try Endpoint.teams.urlRequest(baseURL: baseURL, locale: .enGB)
        #expect(request.value(forHTTPHeaderField: "locale") == "en_UK")
    }

    @Test func omitsBodyByDefault() throws {
        let request = try Endpoint.teams.urlRequest(baseURL: baseURL, locale: .enUS)
        #expect(request.httpBody == nil)
        #expect(request.value(forHTTPHeaderField: "Content-Type") == nil)
    }

    @Test func encodesBody() throws {
        let request = try Endpoint.jobTitles.urlRequest(
            baseURL: baseURL,
            locale: .enUS,
            body: JobTitlesRequest(jobIds: ["1"])
        )
        #expect(request.httpBody == Data(#"{"jobIds":["1"]}"#.utf8))
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }
}
