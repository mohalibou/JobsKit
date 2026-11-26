//
//  JobTitleResponse.swift
//  JobsKit
//

/// An element of the response of `Endpoint.jobTitles`.
struct JobTitleResponse: Decodable, Hashable, Sendable {
    let positionID: String
    let postingTitle: String
}
