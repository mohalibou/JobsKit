//
//  MappingTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

struct MappingTests {
    private func decode<Response: Decodable>(
        _ type: Response.Type,
        from fixture: Fixture
    ) throws -> Response {
        try JSONDecoder().decode(Envelope<Response>.self, from: fixture.data()).res
    }

    // MARK: Dates

    @Test(arguments: [
        ("1970-01-01T00:00:01Z", 1),
        ("1970-01-01T00:00:01.5Z", 1.5),
        ("1970-01-01T00:00:01.250000000Z", 1.25),
        ("1970-01-01T01:00:01.500+01:00", 1.5),
    ])
    func readsTimestamp(string: String, seconds: Double) throws {
        let date = try #require(Date(appleTimestamp: string))
        #expect(abs(date.timeIntervalSince1970 - seconds) < 0.001)
    }

    @Test(arguments: ["", "Nov 24, 2026", "2026-11-24"])
    func rejectsOtherDates(_ string: String) {
        #expect(Date(appleTimestamp: string) == nil)
    }

    // MARK: Jobs

    @Test func mapsJob() throws {
        let response = try decode(SearchResponse.self, from: .search)
        let job = try #require(JobPage(response, number: 1).jobs.first)

        #expect(job.id.rawValue == "100000001-0001")
        #expect(job.positionID.rawValue == "100000001")
        #expect(job.title == "Example Engineer")
        #expect(job.summary == "Summary text.")
        #expect(job.postedAt == Date(appleTimestamp: "2026-01-15T12:00:00.123Z"))
        #expect(job.postedAt != nil)
        #expect(job.isEvergreen == false)
        #expect(job.isRemote == false)
        #expect(job.weeklyHours == 40)
        #expect(job.team?.id == .appleRetail)
        #expect(job.locations.first?.name == "Example Store")
        #expect(job.locations.first?.level == .store)
    }

    @Test func evergreenJobHasNoDate() throws {
        let response = try decode(SearchResponse.self, from: .search)
        let evergreen = JobPage(response, number: 1).jobs.filter(\.isEvergreen)
        let job = try #require(evergreen.first)

        #expect(job.id.rawValue == "PIPE-100000002")
        #expect(job.postedAt == nil)
    }

    @Test func mapsRemoteJob() throws {
        let response = try decode(SearchResponse.self, from: .search)
        let jobs = JobPage(response, number: 1).jobs

        #expect(jobs.map(\.isRemote) == [false, false, true])
        #expect(jobs.last?.weeklyHours == 37.5)
        #expect(jobs.last?.team?.id == .hardware)
    }

    @Test func mapsJobDetails() throws {
        let details = JobDetails(try decode(JobDetailsResponse.self, from: .jobDetails))

        #expect(details.positionID.rawValue == "100000004")
        #expect(details.roleNumber == "100000004-0004")
        #expect(details.title == "Example Lead")
        #expect(details.postedAt == Date(appleTimestamp: "2026-01-20T08:30:00.250+00:00"))
        #expect(details.postedAt != nil)
        #expect(details.employmentType == .standard)
        #expect(details.responsibilities == nil)
        #expect(details.teamNames == ["Apple Retail", "Students", "Support and Service"])
        #expect(details.locations.first?.city == "Springfield")
        #expect(details.locations.first?.postalCode == "00000")
    }

    @Test func mapsLocationDetails() throws {
        let details = JobDetails(try decode(JobDetailsResponse.self, from: .jobDetails))
        let location = try #require(details.locationDetails.first)

        #expect(location.locationID.rawValue == "postLocation-EX2")
        #expect(location.payRange?.period == .hour)

        // The fixture lists these in reverse.
        #expect(location.sections["en_US"]?.map(\.title) == [
            "Pay & Benefits", "EEO Statement", "Accessibility", "Application Deadline",
        ])
    }

    @Test func emptyStringsBecomeNil() throws {
        let json = #"{"id":"1","positionId":"1","postingTitle":"T","jobSummary":"","team":null}"#
        let job = Job(try JSONDecoder().decode(JobPostingResponse.self, from: Data(json.utf8)))

        #expect(job.summary == nil)
        #expect(job.postedAt == nil)
        #expect(job.team == nil)
        #expect(job.locations.isEmpty)
    }

    // MARK: Locations

    @Test func locationNameFallsBack() throws {
        let json = #"{"id":"postLocation-A","name":"","displayName":"","titleName":""}"#
        let location = Location(try JSONDecoder().decode(LocationResponse.self, from: Data(json.utf8)))

        #expect(location.name == "postLocation-A")
        #expect(location.displayName == nil)
    }
}
