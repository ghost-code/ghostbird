//
//  TwitterAPI+Tweet.swift
//  ghostbird
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

    func getTweets(forTweetIDs ids: [String]) async throws -> TwitterAPI.Models.Tweets {
        var queryItems: [URLQueryItem] = []
        queryItems.append(TwitterAPI.QueryItems.expansions)
        queryItems.append(TwitterAPI.QueryItems.userFields)
        queryItems.append(TwitterAPI.QueryItems.tweetFields)

        let idsString = ids.map { String($0) }.joined(separator: ",")

        queryItems.append(.init(name: "ids", value: idsString))

        return try await performRequest(method: .get,
                                        path: "/2/tweets",
                                        queryItems: queryItems)
    }
    
    func getTweets(forTweetID id: String) async throws -> TwitterAPI.Models.Tweet {
        var queryItems: [URLQueryItem] = []
        queryItems.append(TwitterAPI.QueryItems.expansions)
        queryItems.append(TwitterAPI.QueryItems.userFields)
        queryItems.append(TwitterAPI.QueryItems.tweetFields)

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
            let public_metrics: PublicMetrics
            let lang: String?
            let entities: Entities?

            struct PublicMetrics: Decodable {
                let retweet_count: Int
                let reply_count: Int
                let like_count: Int
                let quote_count: Int
            }

            struct ReferencedTweet: Decodable {
                let type: String
                let id: String
            }

            struct Entities: Decodable {
                let cashtags: [Cashtag]?
                let hashtags: [Hashtag]?
                let mentions: [Mention]?
                let urls: [URLEntity]?
                let annotations: [Annotation]?
            }
        }

        struct Includes: Decodable {
            let users: [User.Data]
            let tweets: [Tweet.Data]?
        }
    }

}

extension TwitterAPI.Models.Tweet.Data.Entities {

    struct Mention: Decodable {
        let start: Int
        let end: Int
        let username: String
        let id: String
    }

    struct Hashtag: Decodable {
        let start: Int
        let end: Int
        let tag: String
    }

    struct Annotation: Decodable {
        let start: Int
        let end: Int
        let url: URL?
        let probability: Double
        let type: String
        let normalized_text: String
    }

    struct Cashtag: Decodable {
        let start: Int
        let end: Int
        let tag: String
    }

    struct URLEntity: Decodable {
        let start: Int
        let end: Int
        let url: URL
        let expanded_url: URL
        let display_url: String
        let status: Int?
        let description: String?
        let unwound_url: URL?
    }

}
