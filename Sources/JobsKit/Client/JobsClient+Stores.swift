//
//  JobsClient+Stores.swift
//  JobsKit
//

extension JobsClient {
    
    /// Stores in a location for a retail job.
    public func stores(for job: JobID, in location: LocationID) async throws -> [Store] {
        try await stores(for: job, search: .location(id: location.rawValue))
    }
    
    /// Stores near a ZIP code for a retail job.
    public func stores(
        for job: JobID,
        nearZIPCode zipCode: String,
        withinMiles miles: Int = 25
    ) async throws -> [Store] {
        try await stores(for: job, search: .zipCode(zipCode, miles: miles))
    }
    
    /// The pay and benefits text for a job at a location, if there is any.
    public func payAndBenefits(for job: JobID, at location: LocationID) async throws -> String? {
        let response: StoreBenefitsResponse = try await http.send(
            .storeBenefits(jobID: job.rawValue, locationID: location.rawValue)
        )
        return response.payAndBenefitsText?.nonEmpty
    }
    
    private func stores(for job: JobID, search: Endpoint.StoreSearch) async throws -> [Store] {
        let response: StoresResponse = try await http.send(
            .stores(jobID: job.rawValue, search: search)
        )
        return response.stores.map(Store.init)
    }
}
