//
//  Envelope.swift
//  JobsKit
//

/// The `{ "res": ... }` object that wraps Apple's responses.
struct Envelope<Response: Decodable>: Decodable {
    let res: Response
}

extension Envelope: Sendable where Response: Sendable {}
