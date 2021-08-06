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

    @Published var conversationIsActive: Bool = false

    @Published var elementIsActive: Bool = false {
        didSet {
            if !elementIsActive && activeElement != nil{
                activeElement = nil
            }
        }
    }

    var activeElement: TweetTextElement? = nil {
        didSet {
            elementIsActive = activeElement != nil
        }
    }

    @Published var errorIsActive: Bool = false {
        didSet {
            if !errorIsActive && activeError != nil {
                activeError = nil
            }
        }
    }

    var activeError: Error? {
        didSet {
            errorIsActive = activeError != nil

        }
    }

    let api: TwitterAPIProtocol
    let id: String
    let conversationID: String
    let text: String
    let author: User
    let date: Date
    let referencedTweetIDs: [String]
    let metrics: Metrics
    let hasReferencedTweets: Bool
    let tweetText: TweetText
    let language: String?

    init(api: TwitterAPIProtocol,
         id: String,
         text: String,
         date: Date,
         author: User,
         conversationID: String,
         hasReferencedTweets: Bool,
         language: String?,
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
        self.language = language
        self.tweetText = TweetText(string: text, language: language)
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

    func searchResults(for element: TweetTextElement) -> SearchResults {
        SearchResults(api: api, name: element.string, query: element.string)
    }

    var copy: Tweet {
        Tweet(api: api,
              id: id,
              text: text,
              date: date,
              author: author,
              conversationID: conversationID,
              hasReferencedTweets: hasReferencedTweets,
              language: language,
              referencedTweetIDs: referencedTweetIDs,
              metrics: metrics)
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
