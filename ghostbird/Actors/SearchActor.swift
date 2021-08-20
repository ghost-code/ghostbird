//
//  SearchActor.swift
//  ghostbird
//
//  Created by David Russell on 8/19/21.
//

import Foundation

actor SearchActor {

    var query: String
    var nextToken: String?
    var newestTweetID: String?

    init(query: String) {
        self.query = query
    }

    func getTweets() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getTweets(forSearchQuery: query,
                                                               nextToken: nil,
                                                               sinceID: nil)
        nextToken = results.nextToken
        newestTweetID = results.tweets.first?.id
        return results.tweets
    }

    func getNewerTweets() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getTweets(forSearchQuery: query,
                                                               nextToken: nil,
                                                               sinceID: newestTweetID)
        if let firstTweetID = results.tweets.first?.id {
            newestTweetID = firstTweetID
        }
        return results.tweets
    }

    func getOlderTweets() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getTweets(forSearchQuery: query,
                                                               nextToken: nextToken,
                                                               sinceID: nil)
        nextToken = results.nextToken
        return results.tweets
    }
    
}
