//
//  LocationID.swift
//  JobsKit
//

/// Identifies a location, such as `postLocation-CUP`.
public struct LocationID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
