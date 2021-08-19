//
//  ConversationActor.swift
//  ghostbird
//
//  Created by David Russell on 8/18/21.
//

import Foundation

actor ConversationActor {

    private let conversationID: String
    private let referencedTweetIDs: [String]
    private var repliesNextToken: String?
    private let username: String
    private let tweetID: String

    init(tweet: Tweet) {
        self.conversationID = tweet.conversationID
        self.referencedTweetIDs = tweet.referencedTweetIDs
        self.tweetID = tweet.id
        self.username = tweet.author.userName
    }

    func getReferencedTweets() async throws -> [Tweet] {
        return try await TwitterClient.shared.getReferencedTweets(for: referencedTweetIDs)
    }

    func getReplies() async throws -> [Tweet] {
        let replies: [Tweet]
        (replies, repliesNextToken) = try await TwitterClient.shared.getReplies(nextToken: nil,
                                                                                conversationID: conversationID,
                                                                                username: username,
                                                                                tweetID: tweetID,
                                                                                recursive: false)
        return replies
    }

    func getMoreReplies() async throws -> [Tweet] {
        let replies: [Tweet]
        (replies, repliesNextToken) = try await TwitterClient.shared.getReplies(nextToken: repliesNextToken,
                                                                                conversationID: conversationID,
                                                                                username: username,
                                                                                tweetID: tweetID,
                                                                                recursive: false)
        return replies
    }

}
