//
//  TwitterAPI+Search.swift
//  Twitter Tests
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

    func getSearchResults(forQuery query: String,
                          nextToken: String?,
                          sinceID: String?) async throws -> Models.Search {

        var queryItems: [URLQueryItem] = []

        if let nextToken = nextToken {
            queryItems.append(.init(name: "next_token", value: nextToken))
        }

        if let sinceID = sinceID {
            queryItems.append(.init(name: "since_id", value: sinceID))
        }

        queryItems.append(.init(name: "query", value: query))
        queryItems.append(TwitterAPI.QueryItems.expansions)
        queryItems.append(TwitterAPI.QueryItems.userFields)
        queryItems.append(TwitterAPI.QueryItems.tweetFields)
        queryItems.append(.init(name: "max_results", value: "10"))
        
        return try await performRequest(method: .get,
                                        path: "/2/tweets/search/recent",
                                        queryItems: queryItems)
    }

}

extension TwitterAPI.Models {

    struct Search: Decodable {
        let data: [Tweet.Data]?
        let meta: Meta
        let includes: Tweet.Includes?

        struct Meta: Decodable {
            let newest_id: String?
            let oldest_id: String?
            let result_count: Int
            let next_token: String?
        }

    }

}
