//
//  Workplace.swift
//  JobsKit
//

/// Matches jobs by whether they are remote.
public enum Workplace: String, Hashable, Codable, CaseIterable, Sendable {
    case any
    case remoteOnly
    case excludeRemote
}
