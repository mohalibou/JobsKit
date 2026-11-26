//
//  JobsClient+Catalog.swift
//  JobsKit
//

extension JobsClient {
    
    /// Every team and its sub-teams.
    public func teams() async throws -> [Team] {
        let response: [TeamResponse] = try await http.send(.teams)
        return response.map(Team.init)
    }
    
    /// Every product and service.
    public func products() async throws -> [Product] {
        let response: ProductsResponse = try await http.send(.products)
        return response.products.map(Product.init)
    }
    
    /// Languages whose name matches the text, which needs at least two characters.
    public func languages(matching text: String) async throws -> [Language] {
        let response: [CatalogItemResponse] = try await http.send(.languagesMatching(text))
        return response.map(Language.init)
    }
}
