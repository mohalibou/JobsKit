//
//  JobSequenceTests.swift
//  JobsKit
//

import Testing
@testable import JobsKit

@Suite(.tags(.networking))
struct JobSequenceTests {
    @Test func streamsPagesWithoutRepeats() async throws {
        let transport = MockTransport(
            .page(["1", "2"]), .page(["2", "3"]), .page(["3"]), .page(["4"]), .page([])
        )
        var ids: [String] = []

        for try await job in JobsClient.mock(transport).allJobs() {
            ids.append(job.id.rawValue)
        }

        #expect(ids == ["1", "2", "3", "4"])
        let pages = try await transport.requests.map { try $0.jsonBody()?["page"] as? Int }
        #expect(pages == [1, 2, 3, 4, 5])
    }

    @Test func loadsOnlyWhatIsNeeded() async throws {
        let transport = MockTransport(.page(["1", "2"]), .page(["3"]))

        for try await _ in JobsClient.mock(transport).allJobs() {
            break
        }

        #expect(await transport.requests.count == 1)
    }

    @Test func staysFinishedAfterLastPage() async throws {
        let transport = MockTransport(.page([]))
        var iterator = JobsClient.mock(transport).allJobs().makeAsyncIterator()

        #expect(try await iterator.next() == nil)
        #expect(try await iterator.next() == nil)
        #expect(await transport.requests.count == 1)
    }

    @Test func finishesAfterError() async throws {
        let transport = MockTransport(.page(["1"]), .status(404), .page(["2"]))
        var iterator = JobsClient.mock(transport).allJobs().makeAsyncIterator()
        #expect(try await iterator.next()?.id.rawValue == "1")

        do {
            _ = try await iterator.next()
            Issue.record("Expected an error.")
        } catch JobsError.notFound {
            // success
        }

        #expect(try await iterator.next() == nil)
    }

    @Test func stopsWhenCancelled() async {
        let client = JobsClient.mock(MockTransport(.page(["1", "2"])))
        let task = Task {
            for try await job in client.allJobs() {
                #expect(job.id.rawValue == "1", "Job 2 is already loaded, but shouldn't arrive.")
                withUnsafeCurrentTask { $0?.cancel() }
            }
        }

        await #expect(throws: CancellationError.self) {
            try await task.value
        }
    }
}
