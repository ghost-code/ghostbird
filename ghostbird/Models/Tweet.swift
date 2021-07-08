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

    var activeError: Error? { didSet { errorIsActive = activeError != nil } }

    init(api: TwitterAPIProtocol,
         id: String,
         text: String,
         date: Date,
         author: User,
         conversationID: String,
         referencedTweetIDs: [String]? = nil
    ) {
        self.api = api
        self.id = id
        self.text = text
        self.date = date
        self.author = author
        self.conversationID = conversationID
        self.referencedTweetIDs = referencedTweetIDs ?? []
    }

    func getReferencedTweets() async {
        do {
            referencedTweets = try await getReferencedTweets(for: referencedTweetIDs)
        } catch {
            activeError = error
            errorIsActive = true
        }
     }

    func getReplies() async {
        do {
            replies = try await getReplies(nextToken: nil)
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

}
