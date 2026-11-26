//
//  MockTransport.swift
//  JobsKit
//

import Foundation
@testable import JobsKit

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Replies with each step in turn, and records the requests it receives.
actor MockTransport: HTTPTransport {

    enum Step: Sendable {
        case reply(status: Int, body: Data)
        case failure(any Error)

        static func json(_ string: String) -> Step {
            .reply(status: 200, body: Data(string.utf8))
        }

        static func status(_ status: Int) -> Step {
            .reply(status: status, body: Data(#"{"error":"jobsite.general.serviceError"}"#.utf8))
        }

        static func fixture(_ fixture: Fixture) throws -> Step {
            .reply(status: 200, body: try fixture.data())
        }

        static func page(_ ids: [String]) -> Step {
            let jobs = ids.map { #"{"id":"\#($0)","positionId":"1","postingTitle":"Title"}"# }
            return .json(#"{"res":{"totalRecords":9,"searchResults":[\#(jobs.joined(separator: ","))]}}"#)
        }
    }

    struct NoStepsLeft: Error {}

    private var steps: ArraySlice<Step>
    private(set) var requests: [URLRequest] = []

    init(_ steps: Step...) {
        self.steps = steps[...]
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)

        switch steps.popFirst() {
            case .reply(let status, let body):
                guard let url = request.url, let response = HTTPURLResponse(
                    url: url,
                    statusCode: status,
                    httpVersion: nil,
                    headerFields: nil
                ) else { throw URLError(.badURL) }
                return (body, response)
            case .failure(let error):
                throw error
            case nil:
                throw NoStepsLeft()
        }
    }
}

extension HTTPClient {
    static func mock(
        _ transport: MockTransport,
        locale: JobsLocale = .enUS,
        retryDelay: Double = 0
    ) -> HTTPClient {
        HTTPClient(
            locale: locale,
            transport: transport,
            retryPolicy: RetryPolicy(maxAttempts: 3, baseDelay: retryDelay)
        )
    }
}

extension JobsClient {
    static func mock(_ transport: MockTransport, locale: JobsLocale = .enUS) -> JobsClient {
        JobsClient(http: .mock(transport, locale: locale))
    }
}

extension URLRequest {
    func jsonBody() throws -> [String: Any]? {
        try httpBody.flatMap { try JSONSerialization.jsonObject(with: $0) as? [String: Any] }
    }
}
