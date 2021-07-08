//
//  TwitterAPI.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import Foundation

protocol TwitterAPIProtocol {
    func getTrends(for woeid: Int) async throws -> TwitterAPI.Models.Trends
    func getSearchResults(forQuery query: String,
                          sinceID: String?,
                          nextToken: String?) async throws -> TwitterAPI.Models.Search
    func getTweets(for id: String) async throws -> TwitterAPI.Models.Tweet
    func getTweets(for ids: [String]) async throws -> TwitterAPI.Models.Tweets
}

class TwitterAPI: TwitterAPIProtocol {

    private struct Constants {
        static let scheme: String = "https"
        static let host: String = "api.twitter.com"
    }

    var keys: TwitterAPI.Keys

    var accessToken: String?

    init(keys: TwitterAPI.Keys) {
        self.keys = keys
    }

}

extension TwitterAPI { struct Models { } }

extension TwitterAPI {

    func performRequest<T: Decodable>(method: URLRequest.HTTPMethod,
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

    // TODO: Clean this up
    private func postToken() async throws -> TwitterAPI.Models.Token {

        let url = try url(forPath: "/oauth2/token")

        var request = URLRequest(url: url, method: .post)
        request.addValue("Basic " + keys.bearer,
                         forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)

        let urlSession = URLSession.shared
        let (data, response) = try await urlSession.data(for: request)

        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            try handleError(data: data, response: response)
        }

        return try JSONDecoder().decode(TwitterAPI.Models.Token.self, from: data)
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


