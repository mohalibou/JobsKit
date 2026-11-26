//
//  JobsClientTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(.tags(.networking))
struct JobsClientTests {

    // MARK: Jobs

    @Test func searchSendsQueryPageAndLocale() async throws {
        let transport = MockTransport(try .fixture(.search))
        let page = try await JobsClient.mock(transport, locale: .deDE)
            .jobs(matching: JobQuery(text: "swift"), page: 3)

        #expect(page.number == 3)
        #expect(page.totalCount == 3)
        #expect(page.jobs.count == 3)

        let body = try #require(await transport.requests.first?.jsonBody())
        #expect(body["query"] as? String == "swift")
        #expect(body["page"] as? Int == 3)
        #expect(body["locale"] as? String == "de-de")
    }

    @Test func detailsAcceptsEitherID() async throws {
        let transport = MockTransport(try .fixture(.jobDetails), try .fixture(.jobDetails))
        let client = JobsClient.mock(transport)

        _ = try await client.details(for: JobID(rawValue: "100000004-0004"))
        _ = try await client.details(for: PositionID(rawValue: "100000004"))

        let paths = await transport.requests.map { $0.url?.lastPathComponent }
        #expect(paths == ["100000004-0004", "100000004"])
    }

    @Test func titleSuggestions() async throws {
        let transport = MockTransport(.json(#"{"res":["Swift Engineer"]}"#))
        let titles = try await JobsClient.mock(transport).titleSuggestions(for: "swift")
        #expect(titles == ["Swift Engineer"])
    }

    @Test func emptyTitleSuggestionsSkipRequest() async throws {
        let transport = MockTransport()
        #expect(try await JobsClient.mock(transport).titleSuggestions(for: "").isEmpty)
        #expect(await transport.requests.isEmpty)
    }

    // MARK: Locations

    @Test func locations() async throws {
        let transport = MockTransport(try .fixture(.locations))
        let locations = try await JobsClient.mock(transport).locations(matching: "a")

        #expect(locations.map(\.name) == ["Exampleland", "Springfield"])
        #expect(locations.map(\.level) == [.country, .city])
        #expect(locations.last?.stateOrProvince == "Example State")
    }

    @Test func locationsInCountry() async throws {
        let transport = MockTransport(try .fixture(.locations))
        _ = try await JobsClient.mock(transport)
            .locations(matching: "a", in: LocationID(rawValue: "postLocation-USA"))

        let query = try #require(await transport.requests.first?.url?.query)
        #expect(query.contains("countryId=postLocation-USA"))
    }

    @Test func areasSendsIDs() async throws {
        let transport = MockTransport(try .fixture(.locations))
        _ = try await JobsClient.mock(transport)
            .areas(around: [LocationID(rawValue: "postLocation-CUP")])

        let body = try #require(await transport.requests.first?.httpBody)
        #expect(try JSONDecoder().decode([String].self, from: body) == ["postLocation-CUP"])
    }

    @Test func emptyAreasSkipRequest() async throws {
        let transport = MockTransport()
        #expect(try await JobsClient.mock(transport).areas(around: []).isEmpty)
        #expect(await transport.requests.isEmpty)
    }

    // MARK: Catalog

    @Test func teams() async throws {
        let teams = try await JobsClient.mock(MockTransport(try .fixture(.teams))).teams()

        #expect(teams.map(\.id) == [.machineLearningAndAI, .hardware])
        #expect(teams.last?.name == "Hardware")
        #expect(teams.last?.subTeams.first?.name == "Acoustic Technologies")
        #expect(teams.last?.subTeams.first?.filter == TeamFilter.Hardware.acousticTechnologies)
    }

    @Test func products() async throws {
        let products = try await JobsClient.mock(MockTransport(try .fixture(.products))).products()
        #expect(products.map(\.id) == [.appleAds, .airPods])
        #expect(products.map(\.name) == ["Apple Ads", "AirPods"])
    }

    @Test func languages() async throws {
        let languages = try await JobsClient.mock(MockTransport(try .fixture(.languages)))
            .languages(matching: "en")
        #expect(languages.map(\.id.rawValue) == ["language-en_US", "language-en_SG"])
        #expect(languages.first?.name == "English - US")
    }

    // MARK: Stores

    @Test func storesInLocation() async throws {
        let transport = MockTransport(try .fixture(.stores))
        let stores = try await JobsClient.mock(transport)
            .stores(for: JobID(rawValue: "1"), in: LocationID(rawValue: "postLocation-CUP"))

        #expect(stores.map(\.name) == ["Example Plaza", "Example Center"])
        #expect(stores.first?.city == "Springfield")
        #expect(stores.first?.hasPayAndBenefits == true)
        #expect(stores.first?.hasCurrentOpening == false)
    }

    @Test func storesNearZIPCode() async throws {
        let transport = MockTransport(try .fixture(.stores))
        _ = try await JobsClient.mock(transport)
            .stores(for: JobID(rawValue: "1"), nearZIPCode: "95014", withinMiles: 10)

        let query = try #require(await transport.requests.first?.url?.query)
        #expect(query.contains("fieldValue=95014&milesRange=10"))
    }

    @Test(arguments: [#"{"res":""}"#, #"{"res":[]}"#])
    func noStores(_ body: String) async throws {
        let stores = try await JobsClient.mock(MockTransport(.json(body)))
            .stores(for: JobID(rawValue: "1"), in: LocationID(rawValue: "postLocation-CUP"))
        #expect(stores.isEmpty)
    }

    @Test(arguments: [
        (#"{"res":{"payAndBenefitsText":"Pay"}}"#, "Pay"),
        (#"{"res":{"payAndBenefitsText":""}}"#, nil),
        (#"{"res":{}}"#, nil),
    ])
    func payAndBenefits(body: String, expected: String?) async throws {
        let text = try await JobsClient.mock(MockTransport(.json(body)))
            .payAndBenefits(for: JobID(rawValue: "1"), at: LocationID(rawValue: "postLocation-CUP"))
        #expect(text == expected)
    }
}
