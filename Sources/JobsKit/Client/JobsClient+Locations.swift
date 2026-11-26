//
//  JobsClient+Locations.swift
//  JobsKit
//

extension JobsClient {
    
    /// Locations whose name matches the text.
    public func locations(matching text: String) async throws -> [Location] {
        let response: [LocationResponse] = try await http.send(.locations(matching: text))
        return response.map(Location.init)
    }
    
    /// Locations in a country whose name matches the text.
    ///
    /// `country` is a location ID, such as `postLocation-USA`.
    public func locations(matching text: String, in country: LocationID) async throws -> [Location] {
        let response: [LocationResponse] = try await http.send(
            .locationsInCountry(matching: text, countryID: country.rawValue)
        )
        return response.map(Location.init)
    }
    
    /// The next wider areas around locations, such as a city's metro area.
    ///
    /// Results are in no particular order. Apple rejects countries.
    public func areas(around locations: [LocationID]) async throws -> [Location] {
        // Apple returns unrelated areas for an empty list.
        guard !locations.isEmpty else { return [] }
        
        let response: [LocationResponse] = try await http.send(
            .expandLocations,
            body: locations.map(\.rawValue)
        )
        return response.map(Location.init)
    }
}
