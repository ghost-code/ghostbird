//
//  Trend.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import Foundation

@MainActor
class Trend: ObservableObject, Identifiable {

    @Published private(set) var tweets: [Tweet] = []

    let id: String
    let position: Int
    let name: String
    let url: URL
    let query: String
    let tweetVolume: Int?

    private var nextToken: String?
    private let api: TwitterAPIProtocol

    init(api: TwitterAPIProtocol, trendDataObject: TrendDataObject, position: Int) {
        self.api = api
        self.id = trendDataObject.name
        self.position = position
        self.name = trendDataObject.name
        self.url = trendDataObject.url
        self.query = trendDataObject.query.removingPercentEncoding!
        self.tweetVolume = trendDataObject.tweetVolume
    }

    func getSearchResults() async throws {
        let searchResults = try await api.getSearchResults(forQuery: query, nextToken: nextToken)
        self.nextToken = searchResults.meta.next_token
        let users = searchResults.includes.users

        var tweets: [Tweet] = []
        for tweetDataObject in searchResults.data {
            guard let userDataObject = users.first(where: { $0.id == tweetDataObject.author_id }) else { return }
            tweets.append(Tweet(tweetDataObject: tweetDataObject, userDataObject: userDataObject))
        }
        self.tweets.insert(contentsOf: tweets, at: 0)
    }
}
