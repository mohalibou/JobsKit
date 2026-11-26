//
//  StoreResponse.swift
//  JobsKit
//

/// Response of `Endpoint.stores`.
struct StoresResponse: Decodable, Hashable, Sendable {
    let stores: [StoreResponse]
    
    /// Apple returns an empty string instead of an empty array when it has no stores.
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self), string.isEmpty {
            stores = []
        } else {
            stores = try container.decode([StoreResponse].self)
        }
    }
}

struct StoreResponse: Decodable, Hashable, Sendable {
    let locationId: String
    let name: String?
    let city: String?
    let currentOpening: Bool?
    let showPayAndBenefits: Bool?
}

/// Response of `Endpoint.storeBenefits`.
struct StoreBenefitsResponse: Decodable, Hashable, Sendable {
    /// `nil` when the location has no benefits text.
    let payAndBenefitsText: String?
}

// MARK: - Mapping

extension Store {
    init(_ response: StoreResponse) {
        self.init(
            id: LocationID(rawValue: response.locationId),
            name: response.name?.nonEmpty ?? response.locationId,
            city: response.city?.nonEmpty,
            hasCurrentOpening: response.currentOpening ?? false,
            hasPayAndBenefits: response.showPayAndBenefits ?? false
        )
    }
}
