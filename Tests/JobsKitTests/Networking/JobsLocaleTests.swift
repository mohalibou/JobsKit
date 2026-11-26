//
//  JobsLocaleTests.swift
//  JobsKit
//

import Testing
@testable import JobsKit

struct JobsLocaleTests {
    @Test func identifiersAreUnique() {
        #expect(Set(JobsLocale.all.map(\.identifier)).count == JobsLocale.all.count)
    }

    @Test(arguments: JobsLocale.all)
    func identifierRoundTrips(_ locale: JobsLocale) {
        #expect(JobsLocale(identifier: locale.identifier) == locale)
    }

    @Test(arguments: ["en-gb", "EN-GB", "en_GB"])
    func ignoresCaseAndSeparator(_ identifier: String) {
        #expect(JobsLocale(identifier: identifier) == .enGB)
    }

    @Test(arguments: ["", "en", "xx-xx"])
    func rejectsUnknownIdentifier(_ identifier: String) {
        #expect(JobsLocale(identifier: identifier) == nil)
    }

    @Test func usesAppleDataCodes() {
        #expect(JobsLocale.enGB.data == "en_UK")
        #expect(JobsLocale.plPL.data == "en_UK")
        #expect(JobsLocale.deDE.data == "de_DE")
    }
}
