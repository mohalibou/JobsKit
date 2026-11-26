//
//  JobTitlesRequest.swift
//  JobsKit
//

/// Body of `Endpoint.jobTitles`.
struct JobTitlesRequest: Encodable, Hashable, Sendable {
    /// Position IDs, such as `200696418`. Full job IDs return nothing.
    var jobIds: [String]
}
