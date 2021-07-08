//
//  TwitterAPI+Tweet.swift
//  ghostbird
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

    func getTweets(for ids: [String]) async throws -> TwitterAPI.Models.Tweets {
        var queryItems: [URLQueryItem] = []
        queryItems.append(.init(name: "expansions", value: "referenced_tweets.id,referenced_tweets.id.author_id"))
        queryItems.append(.init(name: "tweet.fields", value: "conversation_id,created_at,referenced_tweets"))

        let idsString = ids.map { String($0) }.joined(separator: ",")

        queryItems.append(.init(name: "ids", value: idsString))

        return try await performRequest(method: .get,
                                        path: "/2/tweets",
                                        queryItems: queryItems)
    }
    
    func getTweets(for id: String) async throws -> TwitterAPI.Models.Tweet {
        var queryItems: [URLQueryItem] = []
        queryItems.append(.init(name: "expansions", value: "referenced_tweets.id,referenced_tweets.id.author_id"))
        queryItems.append(.init(name: "tweet.fields", value: "conversation_id,created_at,referenced_tweets"))

        return try await performRequest(method: .get,
                                        path: "/2/tweets/" + id,
                                        queryItems: queryItems)
    }
    
}

extension TwitterAPI.Models {

    struct Tweets: Decodable {
        let data: [Tweet.Data]
        let includes: Tweet.Includes
    }

    struct Tweet: Decodable {

        let data: Data
        let includes: Includes

        struct Data: Decodable {
            let author_id: String?
            let id: String
            let referenced_tweets: [ReferencedTweet]?
            let conversation_id: String
            let text: String
            let created_at: String

            struct ReferencedTweet: Decodable {

                enum ReferenceType: String, Decodable {
                    case reply = "replied_to"
                    case retweet = "is_retweet"
                }

                let type: String
                let id: String
            }
        }

        struct Includes: Decodable {
            let users: [User.Data]
            let tweets: [Tweet.Data]?
        }
    }

}
