//
//  Tweet.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import Foundation

@MainActor
class Tweet: ObservableObject, Identifiable {

    @Published var referencedTweets: [Tweet] = []
    @Published var replies: [Tweet] = []
    @Published var errorIsActive: Bool = false

    let api: TwitterAPIProtocol
    let id: String
    let conversationID: String
    let text: String
    let author: User
    let date: Date
    let referencedTweetIDs: [String]
    let metrics: Metrics
    let hasReferencedTweets: Bool

    var activeError: Error? { didSet { errorIsActive = activeError != nil } }

    init(api: TwitterAPIProtocol,
         id: String,
         text: String,
         date: Date,
         author: User,
         conversationID: String,
         hasReferencedTweets: Bool,
         referencedTweetIDs: [String]? = nil,
         metrics: Metrics
    ) {
        self.api = api
        self.id = id
        self.text = text
        self.date = date
        self.author = author
        self.conversationID = conversationID
        self.hasReferencedTweets = hasReferencedTweets
        self.referencedTweetIDs = referencedTweetIDs ?? []
        self.metrics = metrics
    }

    func getReferencedTweets() async {
        do {
            referencedTweets = try await getReferencedTweets(for: referencedTweetIDs)
        } catch {
            activeError = error
            errorIsActive = true
        }
     }

    func getAllReplies() async {
        do {
            replies = try await getReplies(nextToken: nil, recursive: true)
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

}

extension Tweet {

    struct Metrics {
        let retweetCount: Int
        let replyCount: Int
        let likeCount: Int
        let quoteCount: Int
    }

}
