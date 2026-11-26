//
//  Endpoint.swift
//  JobsKit
//

import Foundation

/// A public, read-only route of the Apple Jobs API.
///
/// Describes the method, path, and query of a request, relative to
/// `https://jobs.apple.com/api/v1`. Bodies for `POST` routes are documented
/// on each case and supplied by the caller.
enum Endpoint: Hashable, Sendable {
    
    // MARK: Jobs
    
    /// Searches job postings.
    ///
    /// Body: `query`, `filters`, `page`, `locale`, `sort`, `format`.
    /// Always include `format`, even if empty; without it the API returns no results.
    case search
    
    /// Full details of a posting.
    case jobDetails(id: String)
    
    /// Titles for a list of positions. Body: `jobIds`, containing position IDs.
    case jobTitles
    
    /// Job titles matching a partial term.
    case titleSuggestions(term: String)
    
    // MARK: Locations
    
    /// Locations whose name matches `input`.
    case locations(matching: String)
    
    /// Locations within a country.
    ///
    /// `countryID` looks like `postLocation-USA`.
    case locationsInCountry(matching: String, countryID: String)
    
    /// The next wider areas around locations. Body: an array of location IDs.
    case expandLocations
    
    // MARK: Stores
    
    /// Apple Store locations for a retail role.
    case stores(jobID: String, search: StoreSearch)
    
    /// Pay and benefits for a role at a location.
    case storeBenefits(jobID: String, locationID: String)
    
    // MARK: Reference data
    
    /// Every product and service.
    case products
    
    /// Every team and its sub-teams.
    case teams
    
    /// Sub-teams whose name matches the input.
    case teamsMatching(String)
    
    /// Languages whose name matches the input. Use at least two characters.
    case languagesMatching(String)
    
    /// Names for location, product, and language IDs.
    ///
    /// Body: `filters`. Returned at most 100 items per request when tested.
    case resolveFilters
}

// MARK: - Supporting Types

extension Endpoint {
    
    enum HTTPMethod: String, Sendable {
        case get = "GET"
        case post = "POST"
    }
    
    enum StoreSearch: Hashable, Sendable {
        /// Stores in a location, such as `postLocation-CUP`.
        case location(id: String)
        
        /// Stores within a distance of a ZIP code.
        case zipCode(String, miles: Int)
    }
}

// MARK: - Request Components

extension Endpoint {
    
    var method: HTTPMethod {
        switch self {
            case .search, .jobTitles, .expandLocations, .resolveFilters:
                    .post
            case .jobDetails, .titleSuggestions,
                    .locations, .locationsInCountry,
                    .stores, .storeBenefits,
                    .products, .teams, .teamsMatching, .languagesMatching:
                    .get
        }
    }
    
    /// The percent-encoded path, for use with `URLComponents.percentEncodedPath`.
    var path: String {
        switch self {
            case .search:                     "/search"
            case .jobDetails(let id):         "/jobDetails/\(Self.encode(id))"
            case .jobTitles:                  "/rolesearch"
            case .titleSuggestions(let term): "/quickfind/\(Self.encode(term))"
            case .locations:                  "/refData/postlocation"
            case .locationsInCountry:         "/refData/postLocationTypeAhead"
            case .expandLocations:            "/expandResults"
            case .stores:                     "/storeLocations"
            case .storeBenefits:              "/storeBenefits"
            case .products:                   "/refData/search"
            case .teams:                      "/refData/teamsofinterest"
            case .teamsMatching:              "/refData/teamsByInput"
            case .languagesMatching:          "/refData/languagesByInput"
            case .resolveFilters:             "/getRefDataById"
        }
    }
    
    func queryItems(for locale: JobsLocale) -> [URLQueryItem] {
        switch self {
            case .search, .jobTitles, .titleSuggestions, .expandLocations,
                    .products, .teams, .resolveFilters:
                []
            case .jobDetails:
                [URLQueryItem(name: "locale", value: locale.site)]
            case .locations(let input), .teamsMatching(let input), .languagesMatching(let input):
                [URLQueryItem(name: "input", value: input)]
            case .locationsInCountry(let input, let countryID):
                [
                    URLQueryItem(name: "input", value: input),
                    URLQueryItem(name: "countryId", value: countryID),
                    URLQueryItem(name: "locale", value: locale.data),
                ]
            case .stores(let jobID, .location(let id)):
                [
                    URLQueryItem(name: "jobId", value: jobID),
                    URLQueryItem(name: "fieldValue", value: id),
                ]
            case .stores(let jobID, .zipCode(let zipCode, let miles)):
                [
                    URLQueryItem(name: "jobId", value: jobID),
                    URLQueryItem(name: "searchField", value: "zipCode"),
                    URLQueryItem(name: "fieldValue", value: zipCode),
                    URLQueryItem(name: "milesRange", value: String(miles)),
                ]
            case .storeBenefits(let jobID, let locationID):
                [
                    URLQueryItem(name: "jobId", value: jobID),
                    URLQueryItem(name: "postLocation", value: locationID),
                    URLQueryItem(name: "locale", value: locale.data),
                ]
        }
    }
    
    /// Encodes a value as a single path component, including any `/`.
    private static func encode(_ component: String) -> String {
        let allowed = CharacterSet.urlPathAllowed.subtracting(CharacterSet(charactersIn: "/"))
        return component.addingPercentEncoding(withAllowedCharacters: allowed) ?? component
    }
}
