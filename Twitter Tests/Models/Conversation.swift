//
//  Conversation.swift
//  Twitter Tests
//
//  Created by David Russell on 7/3/21.
//

import Foundation

//@MainActor
//class Conversation: ObservableObject {
//
//    @Published private(set) var tweets: [Tweet] = []
//    let root: Tweet
//    let replies: [Tweet]
//    let id: String
//    let tweetVolume: Int?
//
//    private var nextToken: String?
//    private let api: TwitterAPIProtocol
//
//    init(api: TwitterAPIProtocol, tweet: Tweet, position: Int) {
//        self.api = api
//        self.id = tweet.id
//    }
//
//    func getSearchResults() async throws {
//        
//        let searchResults = try await api.getSearchResults(forQuery: query, nextToken: nextToken)
//        self.nextToken = searchResults.meta.next_token
//        let users = searchResults.includes.users
//
//        var tweets: [Tweet] = []
//        for tweetDataObject in searchResults.data {
//            guard let userDataObject = users.first(where: { $0.id == tweetDataObject.author_id }) else { return }
//            tweets.append(Tweet(tweetDataObject: tweetDataObject, userDataObject: userDataObject))
//        }
//        self.tweets.insert(contentsOf: tweets, at: 0)
//    }
//}
