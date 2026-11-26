//
//  TeamFilterTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

struct TeamFilterTests {
    @Test func subTeamCarriesItsTeam() {
        #expect(
            TeamFilter.SoftwareAndServices.appsAndFrameworks
                == .subTeam(SubTeamID(rawValue: "subTeam-AF"), in: .softwareAndServices)
        )
    }

    @Test func sharedCodesDifferByTeam() {
        #expect(
            TeamFilter.OperationsAndSupplyChain.softwareEngineering
                != TeamFilter.SupportAndService.supportEngineering
        )
    }
}
