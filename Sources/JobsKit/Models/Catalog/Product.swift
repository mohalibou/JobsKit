//
//  Product.swift
//  JobsKit
//

/// A product or service.
public struct Product: Identifiable, Hashable, Codable, Sendable {
    public let id: ProductID
    public let name: String

    public init(id: ProductID, name: String) {
        self.id = id
        self.name = name
    }
}
