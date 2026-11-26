//
//  JobsErrorTests.swift
//  JobsKit
//

import Foundation
import Testing
import JobsKit

struct JobsErrorTests {
    @Test(arguments: [
        (JobsError.notFound, "This job couldn’t be found. It may no longer be posted."),
        (.http(status: 429), "Too many requests were sent to Apple. Try again later."),
        (.http(status: 436), "Apple couldn’t complete the request. (Status 436)"),
        (
            .http(status: 503),
            "Apple’s jobs service isn’t available right now. Try again later. (Status 503)"
        ),
        (.invalidResponse, "Apple’s response couldn’t be read."),
        (.decoding(CocoaError(.coderReadCorrupt)), "Apple’s response couldn’t be read."),
    ])
    func describesError(error: JobsError, message: String) {
        #expect(error.localizedDescription == message)
    }

    @Test func transportUsesUnderlyingMessage() {
        struct Offline: LocalizedError {
            var errorDescription: String? { "You’re offline." }
        }

        #expect(JobsError.transport(Offline()).localizedDescription == "You’re offline.")
    }
}
