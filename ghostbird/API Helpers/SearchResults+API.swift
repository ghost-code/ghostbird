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

    static func tweets(for apiSearchResults: TwitterAPI.Models.Search, api: TwitterAPIProtocol) -> [Tweet] {
        guard let data = apiSearchResults.data,
              let users = apiSearchResults.includes?.users else { return [] }

        var tweets: [Tweet] = []
        for apiTweet in data {
            guard let apiUser = users.first(where: { $0.id == apiTweet.author_id }) else { return [] }
            tweets.append(Tweet(api: api, apiTweetData: apiTweet, apiUser: apiUser))
        }
        return tweets
    }

    func getTweets() async {
        do {
            let searchResults = try await api.getSearchResults(forQuery: query,
                                                               sinceID: nil,
                                                               nextToken: nil)
            olderTweetsToken = searchResults.meta.next_token
            self.tweets = SearchResults.tweets(for: searchResults, api: api)
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

    func getNewerTweets() async {
        do {
            let searchResults = try await api.getSearchResults(forQuery: query,
                                                               sinceID: tweets.first?.id,
                                                               nextToken: nil)
            self.tweets.insert(contentsOf: SearchResults.tweets(for: searchResults, api: api), at: 0)
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

    func getOlderTweets() async {
        do {
            let searchResults = try await api.getSearchResults(forQuery: query,
                                                               sinceID: nil,
                                                               nextToken: olderTweetsToken)
            self.olderTweetsToken = searchResults.meta.next_token
            tweets.append(contentsOf: SearchResults.tweets(for: searchResults, api: api))
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

}
