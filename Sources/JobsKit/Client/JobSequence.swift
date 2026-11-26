//
//  JobSequence.swift
//  JobsKit
//

/// Every job that matches a query.
///
/// Loads a page at a time, and only as jobs are needed. Skips jobs that repeat,
/// which can happen when new jobs are posted between pages.
public struct JobSequence: AsyncSequence, Sendable {
    public typealias Element = Job
    
    let client: JobsClient
    let query: JobQuery
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(client: client, query: query)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        let client: JobsClient
        let query: JobQuery
        
        private var buffer: ArraySlice<Job> = []
        private var nextPage = 1
        private var seen: Set<JobID> = []
        private var isFinished = false
        
        init(client: JobsClient, query: JobQuery) {
            self.client = client
            self.query = query
        }
        
        public mutating func next() async throws -> Job? {
            try Task.checkCancellation()
            
            while buffer.isEmpty, !isFinished {
                try await loadPage()
            }
            
            return buffer.popFirst()
        }
        
        private mutating func loadPage() async throws {
            let page: JobPage
            
            do {
                page = try await client.jobs(matching: query, page: nextPage)
            } catch {
                isFinished = true
                throw error
            }
            
            nextPage += 1
            isFinished = page.jobs.isEmpty
            buffer = page.jobs.filter { seen.insert($0.id).inserted }[...]
        }
    }
}
