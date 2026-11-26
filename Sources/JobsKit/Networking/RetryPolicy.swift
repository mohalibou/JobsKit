//
//  RetryPolicy.swift
//  JobsKit
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Decides which failed requests to repeat, and when.
///
/// Every endpoint is read-only, so any request is safe to repeat.
struct RetryPolicy: Hashable, Sendable {
    /// Includes the first attempt.
    var maxAttempts = 3
    
    /// Seconds before the first retry. Doubles with each one after.
    var baseDelay = 0.5
    
    func shouldRetry(status: Int) -> Bool {
        [429, 500, 502, 503, 504].contains(status)
    }
    
    func shouldRetry(_ error: any Error) -> Bool {
        switch (error as? URLError)?.code {
            case .timedOut, .networkConnectionLost, .cannotConnectToHost:
                true
            default:
                false
        }
    }
    
    /// Waits before the attempt that follows `attempt`, which starts at 1.
    func wait(after attempt: Int) async throws {
        let seconds = baseDelay * pow(2, Double(attempt - 1))
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
