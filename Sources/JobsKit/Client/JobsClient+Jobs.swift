//
//  JobsClient+Jobs.swift
//  JobsKit
//

extension JobsClient {
    
    /// A page of jobs, up to 20. Pages start at 1, and the page after the last is empty.
    public func jobs(matching query: JobQuery = JobQuery(), page: Int = 1) async throws -> JobPage {
        let body = SearchRequest(query, page: page, locale: http.locale.site)
        let response: SearchResponse = try await http.send(.search, body: body)
        return JobPage(response, number: page)
    }
    
    /// Every matching job, loading pages as they're needed.
    public func allJobs(matching query: JobQuery = JobQuery()) -> JobSequence {
        JobSequence(client: self, query: query)
    }
    
    /// The full details of a posting.
    public func details(for id: JobID) async throws -> JobDetails {
        let response: JobDetailsResponse = try await http.send(.jobDetails(id: id.rawValue))
        return JobDetails(response)
    }
    
    /// The full details of a position.
    public func details(for id: PositionID) async throws -> JobDetails {
        let response: JobDetailsResponse = try await http.send(.jobDetails(id: id.rawValue))
        return JobDetails(response)
    }
    
    /// Job titles that match a partial search term.
    public func titleSuggestions(for term: String) async throws -> [String] {
        guard !term.isEmpty else { return [] }
        return try await http.send(.titleSuggestions(term: term))
    }
}
