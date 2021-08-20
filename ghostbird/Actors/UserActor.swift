//
//  UserActor.swift
//  ghostbird
//
//  Created by David Russell on 8/19/21.
//

import Foundation

actor UserActor {

    var userID: String
    var nextTweetToken: String?
    var newestTweetID: String?

    var nextMentionToken: String?
    var newestMentionID: String?

    init(userID: String) {
        self.userID = userID
    }

    func getUser() async throws -> User {
        return try await TwitterClient.shared.getUser(with: userID)
    }

    func getTweets() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getTweets(forUserID: userID,
                                                               nextToken: nil,
                                                               sinceID: nil)
        newestTweetID = results.tweets.first?.id
        nextTweetToken = results.nextToken
        return results.tweets
    }

    func getOlderTweets() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getTweets(forUserID: userID,
                                                               nextToken: nextTweetToken,
                                                               sinceID: nil)
        nextTweetToken = results.nextToken
        return results.tweets
    }

    func getNewerTweets() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getTweets(forUserID: userID,
                                                               nextToken: nil,
                                                               sinceID: newestTweetID)
        if let firstTweetID = results.tweets.first?.id {
            newestTweetID = firstTweetID
        }
        return results.tweets
    }

    func getMentions() async throws -> [Tweet] {
        let results = try await TwitterClient.shared.getMentions(forUserID: userID,
                                                               nextToken: nil,
                                                               sinceID: nil)
        newestMentionID = results.tweets.first?.id
        nextMentionToken = results.nextToken
        return results.tweets
    }
    
}
