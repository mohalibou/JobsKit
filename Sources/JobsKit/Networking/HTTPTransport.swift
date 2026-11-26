//
//  HTTPTransport.swift
//  JobsKit
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Sends requests. Conform to this to replace `URLSession`, such as in tests.
public protocol HTTPTransport: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

/// Sends requests with a `URLSession`.
public struct URLSessionTransport: HTTPTransport {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw JobsError.invalidResponse
        }
        
        return (data, response)
    }
}
