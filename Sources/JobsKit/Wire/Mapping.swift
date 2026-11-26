//
//  Mapping.swift
//  JobsKit
//

import Foundation

extension String {
    /// `nil` if the string is empty, which Apple often sends for unknown values.
    var nonEmpty: String? {
        isEmpty ? nil : self
    }
}

extension Date {
    /// Parses Apple's ISO 8601 dates, with any number of fractional digits.
    init?(appleTimestamp string: String) {
        var base = string
        var fraction = 0.0
        
        if let range = string.range(of: #"\.[0-9]+"#, options: .regularExpression) {
            fraction = Double("0" + string[range]) ?? 0
            base.removeSubrange(range)
        }
        
        guard let date = ISO8601DateFormatter().date(from: base) else { return nil }
        self = date.addingTimeInterval(fraction)
    }
}
