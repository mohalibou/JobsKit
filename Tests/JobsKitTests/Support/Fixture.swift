//
//  Fixture.swift
//  JobsKit
//

import Foundation
@testable import JobsKit

/// Responses saved from Apple, shortened and with their prose replaced.
enum Fixture: String {
    case jobDetails = "job-details"
    case languages
    case locations
    case products
    case search
    case stores
    case teams

    func data() throws -> Data {
        guard let url = Bundle.module.url(
            forResource: rawValue,
            withExtension: "json",
            subdirectory: "Fixtures"
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }

        return try Data(contentsOf: url)
    }
}
