//
//  LocationLevel.swift
//  JobsKit
//

/// How specific a location is. Higher values are more specific.
public struct LocationLevel: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let country = LocationLevel(rawValue: 1)
    public static let state = LocationLevel(rawValue: 3)
    public static let metro = LocationLevel(rawValue: 4)
    public static let city = LocationLevel(rawValue: 5)
    public static let store = LocationLevel(rawValue: 6)
}
