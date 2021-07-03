//
//  TwitterAPI.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import Foundation

protocol TwitterAPIProtocol {
    func getTrends(for id: String?) async throws -> TrendsResponse
    func getSearchResults(forQuery query: String, nextToken: String?) async throws -> SearchResponse
//    func getSearchResults(forToken token: String) async throws -> SearchResponse
}

class TwitterAPI: TwitterAPIProtocol {

    var accessToken: String?

    func getTrends(for locationID: String?) async throws -> TrendsResponse {
        var queryItems: [URLQueryItem] = []

        queryItems.append(.init(name: "id", value: locationID ?? "1"))

        return try await performRequest(method: .get,
                                        path: "/1.1/trends/place.json",
                                        queryItems: queryItems)
    }

    func getSearchResults(forQuery query: String,
                          nextToken: String?) async throws -> SearchResponse {

        var queryItems: [URLQueryItem] = []
        if let nextToken = nextToken {
            queryItems.append(.init(name: "next_token", value: nextToken))
        }
        
        queryItems.append(.init(name: "query", value: query))
        queryItems.append(.init(name: "expansions", value: "author_id"))
        queryItems.append(.init(name: "user.fields", value: "profile_image_url,username,name"))

        return try await performRequest(method: .get,
                                        path: "/2/tweets/search/recent",
                                        queryItems: queryItems)
    }

    func getSearchResults(forToken token: String) async throws -> SearchResponse {
        var queryItems: [URLQueryItem] = []
        queryItems.append(.init(name: "next_token", value: token))
        return try await performRequest(method: .get,
                                        path: "/2/tweets/search/recent",
                                        queryItems: queryItems)
    }
}

extension TwitterAPI {

    private struct Constants {
        static let apiKey: String =  ""
        static let apiSecretKey: String = ""
        static let scheme: String = "https"
        static let host: String = "api.twitter.com"
        static var bearerTokenCredentials: String {
            let authString = Constants.apiKey + ":" + Constants.apiSecretKey
            return authString.data(using: .utf8)!.base64EncodedString()
        }
    }

    private func performRequest<T: Decodable>(method: HTTPMethod,
                                              path: String,
                                              queryItems: [URLQueryItem]? = nil) async throws -> T {

        if accessToken == nil {
            accessToken = try await postToken().accessToken
        }

        guard let accessToken = accessToken else { throw APIError.noToken }

        let url = try url(forPath: path, queryItems: queryItems)

        var request = URLRequest(url: url, method: method)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        return try await perform(request: request)
    }

    private func perform<T: Decodable>(request: URLRequest) async throws -> T {
        let urlSession = URLSession.shared
        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            let error = APIError.responseStatusError(status: response.statusCode,
                                                     message: errorResponse.detail)
            throw error
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    private func postToken() async throws -> TokenResponse {

        let url = try url(forPath: "/oauth2/token")

        var request = URLRequest(url: url, method: .post)
        request.addValue("Basic " + Constants.bearerTokenCredentials,
                         forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)

        let urlSession = URLSession.shared
        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            try handleError(data: data, response: response)
        }

        return try JSONDecoder().decode(TokenResponse.self, from: data)
    }

    func handleError(data: Data, response: HTTPURLResponse) throws {
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
        let error = APIError.responseStatusError(status: response.statusCode,
                                                 message: errorResponse.detail)
        throw error
    }

    private func url(forPath path: String, queryItems: [URLQueryItem]? = nil) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw APIError.apiBadURL
        }

        return url
    }
}

extension URLRequest {
    init(url: URL, method: HTTPMethod) {
        self = .init(url: url)
        httpMethod = method.rawValue
    }
}

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

extension TwitterAPI {
    enum APIError: Error, LocalizedError {
        case apiBadURL,
             apiNoData,
             responseStatusError(status: Int, message: String),
             noToken

        public var errorDescription: String? {
            switch self {
            case let .responseStatusError(_ , message):
                return message
            default:
                return ""
            }
        }
    }
}


