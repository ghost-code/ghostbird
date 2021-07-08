//
//  SearchResults+API.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

extension SearchResults {

    convenience init(api: TwitterAPIProtocol, apiTrend: TwitterAPI.Models.Trend) {
        self.init(api: api,
                  id: apiTrend.name,
                  name: apiTrend.name,
                  query: apiTrend.query.removingPercentEncoding! + " -is:retweet")
    }

    func getTweets() async throws {
        let searchResults = try await api.getSearchResults(forQuery: query,
                                                           sinceID: nil,
                                                           nextToken: nil)

        guard let data = searchResults.data, let users = searchResults.includes?.users else { return }

        var tweets: [Tweet] = []
        for apiTweet in data {
            guard let apiUser = users.first(where: { $0.id == apiTweet.author_id }) else { return }
            tweets.append(Tweet(api: api, apiTweetData: apiTweet, apiUser: apiUser))
        }

        self.tweets = tweets
    }

    func getNewerTweets() async throws {
        let searchResults = try await api.getSearchResults(forQuery: query,
                                                           sinceID: tweets.first?.id,
                                                           nextToken: nil)

        guard let data = searchResults.data, let users = searchResults.includes?.users else { return }

        var newerTweets: [Tweet] = []
        for apiTweet in data {
            guard let apiUser = users.first(where: { $0.id == apiTweet.author_id }) else { return }
            newerTweets.append(Tweet(api: api, apiTweetData: apiTweet, apiUser: apiUser))
        }

        self.tweets.insert(contentsOf: newerTweets, at: 0)
    }

    func getOlderTweets() async throws {
        let searchResults = try await api.getSearchResults(forQuery: query,
                                                           sinceID: nil,
                                                           nextToken: olderTweetsToken)
        self.olderTweetsToken = searchResults.meta.next_token

        guard let data = searchResults.data, let users = searchResults.includes?.users else { return }

        var olderTweets: [Tweet] = []
        for apiTweet in data {
            guard let apiUser = users.first(where: { $0.id == apiTweet.author_id }) else { return }
            olderTweets.append(Tweet(api: api, apiTweetData: apiTweet, apiUser: apiUser))
        }

        tweets.append(contentsOf: olderTweets)
    }
    
}
