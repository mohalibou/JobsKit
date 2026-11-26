//
//  JobsError.swift
//  JobsKit
//

import Foundation

/// An error from a request to Apple.
///
/// Cancelling a task throws `CancellationError` instead.
public enum JobsError: Error, Sendable {
    /// The job doesn't exist, or is no longer posted.
    case notFound
    
    /// Apple rejected the request. A status of 436 usually means a bad parameter.
    case http(status: Int)
    
    /// The response wasn't HTTP.
    case invalidResponse
    
    /// The response didn't have the expected format.
    case decoding(any Error)
    
    /// The request couldn't be sent, or no response arrived.
    case transport(any Error)
}

extension JobsError: LocalizedError {
    
    /// A message in English that can be shown to people.
    public var errorDescription: String? {
        switch self {
            case .notFound:
                "This job couldn’t be found. It may no longer be posted."
            case .http(status: 429):
                "Too many requests were sent to Apple. Try again later."
            case .http(let status) where status >= 500:
                "Apple’s jobs service isn’t available right now. Try again later. (Status \(status))"
            case .http(let status):
                "Apple couldn’t complete the request. (Status \(status))"
            case .invalidResponse, .decoding:
                "Apple’s response couldn’t be read."
            case .transport(let error):
                error.localizedDescription
        }
    }
}
