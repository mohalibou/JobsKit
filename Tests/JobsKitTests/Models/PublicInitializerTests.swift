//
//  PublicInitializerTests.swift
//  JobsKit
//

import Foundation
import Testing

// Not @testable, so this compiles only if the initializers are public.
import JobsKit

struct PublicInitializerTests {
    let locationID = LocationID(rawValue: "postLocation-CUP")

    @Test func jobNeedsOnlyEssentials() {
        let job = Job(
            id: JobID(rawValue: "1-1"),
            positionID: PositionID(rawValue: "1"),
            title: "Engineer"
        )

        #expect(job.title == "Engineer")
        #expect(job.postedAt == nil)
        #expect(job.isRemote == false)
        #expect(job.locations.isEmpty)
    }

    @Test func fullJob() {
        let date = Date(timeIntervalSince1970: 1)
        let job = Job(
            id: JobID(rawValue: "1-1"),
            positionID: PositionID(rawValue: "1"),
            title: "Engineer",
            summary: "Summary",
            postedAt: date,
            isEvergreen: true,
            isRemote: true,
            weeklyHours: 40,
            team: Job.Team(id: .hardware, name: "Hardware"),
            locations: [
                Job.Location(id: locationID, name: "Cupertino", country: "USA", level: .city),
            ]
        )

        #expect(job.positionID.rawValue == "1")
        #expect(job.summary == "Summary")
        #expect(job.postedAt == date)
        #expect(job.isEvergreen)
        #expect(job.isRemote)
        #expect(job.weeklyHours == 40)
        #expect(job.team?.name == "Hardware")
        #expect(job.locations.first?.country == "USA")
    }

    @Test func jobPageCountsItsJobs() {
        let job = Job(id: JobID(rawValue: "1"), positionID: PositionID(rawValue: "1"), title: "A")

        #expect(JobPage(jobs: [job]).totalCount == 1)
        #expect(JobPage(jobs: [job]).number == 1)
        #expect(JobPage(jobs: [job], totalCount: 50, number: 2).totalCount == 50)
    }

    @Test func jobDetails() {
        let pay = PayRange(minimum: 10, maximum: 20, period: .hour)
        let details = JobDetails(
            positionID: PositionID(rawValue: "1"),
            title: "Engineer",
            employmentType: .intern,
            locations: [JobDetails.Location(id: locationID, city: "Cupertino")],
            locationDetails: [
                JobDetails.LocationDetails(
                    locationID: locationID,
                    sections: ["en_US": [JobDetails.Section(title: "Pay", content: "Text")]],
                    payRange: pay
                ),
            ]
        )

        #expect(details.employmentType == .intern)
        #expect(details.locations.first?.city == "Cupertino")
        #expect(details.locationDetails.first?.payRange == pay)
        #expect(details.teamNames.isEmpty)
    }

    @Test func locationsAndStores() {
        #expect(Location(id: locationID, name: "Cupertino").displayName == nil)
        #expect(Store(id: locationID, name: "Store").hasCurrentOpening == false)
    }

    @Test func catalog() {
        let subTeam = SubTeam(
            id: SubTeamID(rawValue: "subTeam-ARCH"),
            teamID: .hardware,
            name: "Architecture"
        )

        #expect(Team(id: .hardware, name: "Hardware", subTeams: [subTeam]).subTeams == [subTeam])
        #expect(JobsKit.Product(id: .siri, name: "Siri").id == .siri)
        #expect(Language(id: LanguageID(rawValue: "language-en_US"), name: "English").name == "English")
    }
}
