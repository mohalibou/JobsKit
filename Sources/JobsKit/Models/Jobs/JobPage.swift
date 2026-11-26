//
//  JobPage.swift
//  JobsKit
//

/// A page of search results.
public struct JobPage: Hashable, Codable, Sendable {
    public let jobs: [Job]
    
    /// The number of matching jobs across every page.
    public let totalCount: Int
    
    /// Starts at 1.
    public let number: Int

    /// `totalCount` defaults to the number of jobs given.
    public init(
        jobs: [Job],
        totalCount: Int? = nil,
        number: Int = 1
    ) {
        self.jobs = jobs
        self.totalCount = totalCount ?? jobs.count
        self.number = number
    }
}
