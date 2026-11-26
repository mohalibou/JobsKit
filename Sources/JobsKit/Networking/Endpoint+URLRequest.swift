//
//  Endpoint+URLRequest.swift
//  JobsKit
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Endpoint {
    
    func urlRequest(
        baseURL: URL,
        locale: JobsLocale,
        body: (any Encodable & Sendable)? = nil
    ) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }
        
        if components.percentEncodedPath.hasSuffix("/") {
            components.percentEncodedPath.removeLast()
        }
        components.percentEncodedPath += path
        
        let queryItems = queryItems(for: locale)
        if !queryItems.isEmpty {
            components.queryItems = queryItems
            
            // Servers can read an unescaped plus as a space.
            components.percentEncodedQuery = components.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(locale.data, forHTTPHeaderField: "locale")
        
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
