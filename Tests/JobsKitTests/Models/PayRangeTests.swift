//
//  PayRangeTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

struct PayRangeTests {
    @Test func readsYearlyPay() throws {
        let range = try #require(PayRange(text: "role is between $142,300 and $263,300, and your"))
        #expect(range.minimum == 142_300)
        #expect(range.maximum == 263_300)
        #expect(range.period == .year)
    }

    @Test func readsHourlyPay() throws {
        let range = try #require(PayRange(text: "role is between $31.21 and $46.87/hr, and your"))
        #expect(range.minimum == Decimal(string: "31.21"))
        #expect(range.maximum == Decimal(string: "46.87"))
        #expect(range.period == .hour)
    }

    @Test(arguments: [
        "",
        "No pay here.",
        "between Pay rate not available and Pay rate not available/hr",
        "between $20 and $10",
    ])
    func ignoresUnreadableText(_ text: String) {
        #expect(PayRange(text: text) == nil)
    }
}
