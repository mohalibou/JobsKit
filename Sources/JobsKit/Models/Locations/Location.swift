//
//  Location.swift
//  JobsKit
//

/// A place that jobs can be searched in.
public struct Location: Identifiable, Hashable, Codable, Sendable {
    public let id: LocationID
    
    /// A short name, such as "Cupertino".
    public let name: String
    
    /// A full name, such as "Cupertino, California, United States".
    public let displayName: String?
    
    public let city: String?
    public let stateOrProvince: String?
    public let level: LocationLevel?

    public init(
        id: LocationID,
        name: String,
        displayName: String? = nil,
        city: String? = nil,
        stateOrProvince: String? = nil,
        level: LocationLevel? = nil
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.city = city
        self.stateOrProvince = stateOrProvince
        self.level = level
    }
}
