//
//  LocationResponse.swift
//  JobsKit
//

/// An element of the responses of `Endpoint.locations`,
/// `Endpoint.locationsInCountry`, and `Endpoint.expandLocations`.
struct LocationResponse: Decodable, Hashable, Sendable {
    let id: String
    let code: String?
    let name: String?
    let displayName: String?
    let titleName: String?
    let city: String?
    let stateProvince: String?
    
    /// 1 is a country, 3 a state, 4 a metro area, 5 a city, and 6 a store, in the samples seen.
    let level: Int?
}

// MARK: - Mapping

extension Location {
    init(_ response: LocationResponse) {
        self.init(
            id: LocationID(rawValue: response.id),
            name: response.titleName?.nonEmpty ?? response.name?.nonEmpty ?? response.id,
            displayName: response.displayName?.nonEmpty,
            city: response.city?.nonEmpty,
            stateOrProvince: response.stateProvince?.nonEmpty,
            level: response.level.map(LocationLevel.init)
        )
    }
}
