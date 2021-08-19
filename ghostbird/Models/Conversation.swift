//
//  Conversation.swift
//  ghostbird
//
//  Created by David Russell on 8/17/21.
//

import Foundation

@MainActor
class Conversation: ObservableObject {

    let tweet: Tweet
    var observableError: ObservableError = ObservableError()

    @Published var replies: [Tweet] = []
    @Published var referencedTweets: [Tweet] = []

    private var conversationActor: ConversationActor

    init(tweet: Tweet) {
        self.tweet = tweet
        self.conversationActor = ConversationActor(tweet: tweet)
    }

    func getReplies() async {
        do {
            replies += try await conversationActor.getReplies()
        } catch {
            observableError.activeError = error
        }
    }

    func getReferencedTweets() async {
        do {
            referencedTweets = try await conversationActor.getReferencedTweets()
        } catch {
            observableError.activeError = error
        }
    }

}
