//
//  HTTPClientTests.swift
//  JobsKit
//

import Foundation
import Testing
@testable import JobsKit

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(.tags(.networking))
struct HTTPClientTests {
    let success = MockTransport.Step.json(#"{"res":["a"]}"#)

    private func send(_ transport: MockTransport) async throws -> [String] {
        try await HTTPClient.mock(transport).send(.titleSuggestions(term: "a"))
    }

    @Test func unwrapsEnvelope() async throws {
        let transport = MockTransport(success)
        #expect(try await send(transport) == ["a"])
        #expect(await transport.requests.count == 1)
    }

    @Test(arguments: [429, 500, 502, 503, 504])
    func retriesStatus(_ status: Int) async throws {
        let transport = MockTransport(.status(status), success)
        #expect(try await send(transport) == ["a"])
        #expect(await transport.requests.count == 2)
    }

    @Test(arguments: [URLError.Code.timedOut, .networkConnectionLost, .cannotConnectToHost])
    func retriesConnectionFailure(_ code: URLError.Code) async throws {
        let transport = MockTransport(.failure(URLError(code)), success)
        #expect(try await send(transport) == ["a"])
        #expect(await transport.requests.count == 2)
    }

    @Test func givesUpOnStatusAfterThreeAttempts() async {
        let transport = MockTransport(.status(503), .status(503), .status(503), success)

        do {
            _ = try await send(transport)
            Issue.record("Expected an error.")
        } catch JobsError.http(status: 503) {
            // success
        } catch {
            Issue.record("Wrong error thrown: \(error)")
        }

        #expect(await transport.requests.count == 3)
    }

    @Test func givesUpOnTimeoutAfterThreeAttempts() async {
        let timeout = MockTransport.Step.failure(URLError(.timedOut))
        let transport = MockTransport(timeout, timeout, timeout, success)

        do {
            _ = try await send(transport)
            Issue.record("Expected an error.")
        } catch JobsError.transport(let error as URLError) {
            #expect(error.code == .timedOut)
        } catch {
            Issue.record("Wrong error thrown: \(error)")
        }

        #expect(await transport.requests.count == 3)
    }

    @Test func doesNotRetryWhenOffline() async {
        let transport = MockTransport(.failure(URLError(.notConnectedToInternet)), success)

        do {
            _ = try await send(transport)
            Issue.record("Expected an error.")
        } catch JobsError.transport {
            // success
        } catch {
            Issue.record("Wrong error thrown: \(error)")
        }

        #expect(await transport.requests.count == 1)
    }

    @Test func throwsNotFound() async {
        let transport = MockTransport(.status(404), success)

        do {
            _ = try await send(transport)
            Issue.record("Expected an error.")
        } catch JobsError.notFound {
            // success
        } catch {
            Issue.record("Wrong error thrown: \(error)")
        }

        #expect(await transport.requests.count == 1)
    }

    @Test(arguments: [400, 401, 436])
    func throwsOtherStatusWithoutRetrying(_ status: Int) async {
        let transport = MockTransport(.status(status), success)

        do {
            _ = try await send(transport)
            Issue.record("Expected an error.")
        } catch JobsError.http(let thrown) {
            #expect(thrown == status)
        } catch {
            Issue.record("Wrong error thrown: \(error)")
        }

        #expect(await transport.requests.count == 1)
    }

    @Test(arguments: ["", "{}", #"{"res":"a"}"#])
    func throwsDecodingForUnexpectedBody(_ body: String) async {
        do {
            _ = try await send(MockTransport(.json(body)))
            Issue.record("Expected an error.")
        } catch JobsError.decoding {
            // success
        } catch {
            Issue.record("Wrong error thrown: \(error)")
        }
    }

    @Test func throwsCancellationFromTransport() async {
        for error in [CancellationError(), URLError(.cancelled)] as [any Error] {
            let transport = MockTransport(.failure(error), success)
            await #expect(throws: CancellationError.self) {
                try await send(transport)
            }
            #expect(await transport.requests.count == 1)
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func stopsRetryingWhenCancelled() async {
        let transport = MockTransport(.status(503), success)
        let client = HTTPClient.mock(transport, retryDelay: 600)
        let task = Task { () -> [String] in
            try await client.send(.titleSuggestions(term: "a"))
        }

        while await transport.requests.isEmpty {
            await Task.yield()
        }
        task.cancel()

        await #expect(throws: CancellationError.self) {
            try await task.value
        }
        #expect(await transport.requests.count == 1)
    }
}
