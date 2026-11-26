//
//  HTTPClient.swift
//  JobsKit
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Sends endpoints and decodes their responses.
struct HTTPClient: Sendable {
    var baseURL = URL(string: "https://jobs.apple.com/api/v1")!
    var locale = JobsLocale.enUS
    var transport: any HTTPTransport = URLSessionTransport()
    var retryPolicy = RetryPolicy()
    
    /// Runs off the caller's actor, so decoding never blocks the main thread.
    @concurrent
    func send<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        body: (any Encodable & Sendable)? = nil,
        as type: Response.Type = Response.self
    ) async throws -> Response {
        let request = try endpoint.urlRequest(baseURL: baseURL, locale: locale, body: body)
        let data = try await data(for: request)
        
        do {
            return try JSONDecoder().decode(Envelope<Response>.self, from: data).res
        } catch {
            throw JobsError.decoding(error)
        }
    }
    
    private func data(for request: URLRequest) async throws -> Data {
        var attempt = 1
        
        while true {
            try Task.checkCancellation()
            let canRetry = attempt < retryPolicy.maxAttempts
            
            do {
                let (data, response) = try await transport.send(request)
                
                switch response.statusCode {
                    case 200..<300:
                        return data
                    case let status where canRetry && retryPolicy.shouldRetry(status: status):
                        break
                    case 404:
                        throw JobsError.notFound
                    case let status:
                        throw JobsError.http(status: status)
                }
            } catch is CancellationError {
                throw CancellationError()
            } catch let error as URLError where error.code == .cancelled {
                throw CancellationError()
            } catch let error as JobsError {
                throw error
            } catch {
                guard canRetry, retryPolicy.shouldRetry(error) else {
                    throw JobsError.transport(error)
                }
            }
            
            try await retryPolicy.wait(after: attempt)
            attempt += 1
        }
    }
}
