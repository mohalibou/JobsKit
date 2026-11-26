//
//  JobsClient.swift
//  JobsKit
//

import Foundation

/// Finds and reads jobs at Apple.
///
/// Requests throw `JobsError`, or `CancellationError` if their task is cancelled.
public struct JobsClient: Sendable {
    let http: HTTPClient
    
    public init(
        locale: JobsLocale = .enUS,
        transport: any HTTPTransport = URLSessionTransport()
    ) {
        http = HTTPClient(locale: locale, transport: transport)
    }

    init(http: HTTPClient) {
        self.http = http
    }
}
