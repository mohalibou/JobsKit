//
//  Store.swift
//  JobsKit
//

/// An Apple Store location for a retail role.
public struct Store: Identifiable, Hashable, Codable, Sendable {
    public let id: LocationID
    public let name: String
    public let city: String?
    public let hasCurrentOpening: Bool
    public let hasPayAndBenefits: Bool

    public init(
        id: LocationID,
        name: String,
        city: String? = nil,
        hasCurrentOpening: Bool = false,
        hasPayAndBenefits: Bool = false
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.hasCurrentOpening = hasCurrentOpening
        self.hasPayAndBenefits = hasPayAndBenefits
    }
}
