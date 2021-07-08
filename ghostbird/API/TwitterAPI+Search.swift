//
//  TwitterAPI+Search.swift
//  Twitter Tests
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

    func getSearchResults(forQuery query: String,
                          sinceID: String?,
                          nextToken: String?) async throws -> Models.Search {

        var queryItems: [URLQueryItem] = []

        if let nextToken = nextToken {
            queryItems.append(.init(name: "next_token", value: nextToken))
        }

        if let sinceID = sinceID {
            queryItems.append(.init(name: "since_id", value: sinceID))
        }

        queryItems.append(.init(name: "query", value: query))
        queryItems.append(.init(name: "expansions", value: "author_id,referenced_tweets.id,referenced_tweets.id.author_id"))
        queryItems.append(.init(name: "user.fields", value: "profile_image_url,username,name,verified"))
        queryItems.append(.init(name: "tweet.fields", value: "conversation_id,created_at,referenced_tweets,reply_settings"))
        queryItems.append(.init(name: "max_results", value: "100"))
        
        return try await performRequest(method: .get,
                                        path: "/2/tweets/search/recent",
                                        queryItems: queryItems)
    }

}

extension TwitterAPI.Models {

    struct Search: Decodable {
        let data: [Tweet.Data]?
        let meta: Meta
        let includes: Includes?

        struct Meta: Decodable {
            let newest_id: String?
            let oldest_id: String?
            let result_count: Int
            let next_token: String?
        }

        struct Includes: Decodable {
            let users: [User.Data]
        }
    }

}
