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

    @Published var entityIsActive: Bool = false {
        didSet {
            if !entityIsActive && activeEntity != nil{
                activeEntity = nil
            }
        }
    }

    var activeEntity: TwitterStringEntity? = nil {
        didSet {
            entityIsActive = activeEntity != nil
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
    let entities: Entities
    let date: Date
    let referencedTweetIDs: [String]
    let metrics: Metrics
    let hasReferencedTweets: Bool
    let twitterText: TwitterString
    let language: String?

    init(api: TwitterAPIProtocol,
         id: String,
         text: String,
         twitterText: TwitterString,
         date: Date,
         entities: Entities,
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
        self.entities = entities
        self.author = author
        self.conversationID = conversationID
        self.hasReferencedTweets = hasReferencedTweets
        self.referencedTweetIDs = referencedTweetIDs ?? []
        self.metrics = metrics
        self.language = language
        self.twitterText = twitterText
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

    func hashtagSearch(for entity: TwitterStringEntity) -> Search? {
        entities.hashtags.first(where: { $0.name == entity.string })
    }

    func cashtagSearch(for entity: TwitterStringEntity) -> Search? {
        entities.cashtags.first(where: { $0.name == entity.string })
    }

    var copy: Tweet {
        Tweet(api: api,
              id: id,
              text: text,
              twitterText: twitterText,
              date: date,
              entities: entities,
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

    struct Entities {
        let cashtags: [Search]
        let hashtags: [Search]
        let mentions: [User]
        let urls: [URL]
    }

}
