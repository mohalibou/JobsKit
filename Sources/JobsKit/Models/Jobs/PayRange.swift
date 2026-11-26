//
//  PayRange.swift
//  JobsKit
//

import Foundation

/// A pay range read from the text of a posting.
///
/// Apple publishes pay only as prose, so this is a best effort for English text.
/// It has no currency, because Apple writes US and Canadian dollars alike.
public struct PayRange: Hashable, Codable, Sendable {
    public let minimum: Decimal
    public let maximum: Decimal
    public let period: Period
    
    public enum Period: String, Hashable, Codable, Sendable {
        case hour
        
        /// Assumed when the text doesn't state an hourly rate.
        case year
    }
    
    public init(minimum: Decimal, maximum: Decimal, period: Period) {
        self.minimum = minimum
        self.maximum = maximum
        self.period = period
    }
    
    /// Reads text such as "between $31.21 and $46.87/hr".
    init?(text: String) {
        let pattern = #"between \$([0-9][0-9,]*(?:\.[0-9]+)?) and \$([0-9][0-9,]*(?:\.[0-9]+)?)(/hr)?"#
        
        guard
            let regex = try? NSRegularExpression(pattern: pattern),
            let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
            let minimum = Self.amount(match.range(at: 1), in: text),
            let maximum = Self.amount(match.range(at: 2), in: text),
            minimum <= maximum
                else { return nil }
        
        let isHourly = match.range(at: 3).location != NSNotFound
        self.init(minimum: minimum, maximum: maximum, period: isHourly ? .hour : .year)
    }
    
    private static func amount(_ range: NSRange, in text: String) -> Decimal? {
        guard let range = Range(range, in: text) else { return nil }
        
        return Decimal(
            string: text[range].replacingOccurrences(of: ",", with: ""),
            locale: Locale(identifier: "en_US_POSIX")
        )
    }
}
