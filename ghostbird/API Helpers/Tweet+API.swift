//
//  Tweet+API.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

extension Tweet {

    convenience init(api: TwitterAPIProtocol,
         apiTweetData: TwitterAPI.Models.Tweet.Data,
         apiUser: TwitterAPI.Models.User.Data) {

        self.init(api: api,
                  id: apiTweetData.id,
                  text: apiTweetData.text,
                  date: ISO8601DateFormatter.twitter.date(from: apiTweetData.created_at) ?? .now,
                  author: User(apiUser: apiUser),
                  conversationID: apiTweetData.conversation_id,
                  referencedTweetIDs: apiTweetData.referenced_tweets?.map { $0.id })
    }

    private static func tweets(for apiTweets: TwitterAPI.Models.Tweets, api: TwitterAPIProtocol) -> [Tweet]? {
        var tweets: [Tweet] = []
        let apiTweetsData = apiTweets.data
        for apiTweetData in apiTweetsData {
            if let apiUser = apiTweets.includes.users.first(where: { $0.id == apiTweetData.author_id }) {
                tweets.append(Tweet(api: api, apiTweetData: apiTweetData, apiUser: apiUser))
            }
        }
        return tweets.count > 0 ? tweets : nil
    }

    func getReferencedTweets(for ids: [String]) async throws -> [Tweet] {
        var tweets: [Tweet] = []
        guard ids.count > 0 else { return tweets }
        let apiTweets = try await api.getTweets(for: ids)
        if let referencedTweets = Tweet.tweets(for: apiTweets, api: api) {
            for tweet in referencedTweets {
                tweets.insert(tweet, at: 0)
                let referencedTweetIDs = tweet.referencedTweetIDs

                tweets.append(contentsOf: try await getReferencedTweets(for: referencedTweetIDs))
            }
        }
        return tweets.sorted {
            $0.date < $1.date // TODO: Might not be needed?
        }
    }

    // TODO: This destroys twitter api tweet caps on viral tweets and can be slow
    func getReplies(nextToken: String?) async throws -> [Tweet] {

        var replies: [Tweet] = []
        let query = "conversation_id:" + conversationID + " to:" + author.userName

        let searchResults = try await api.getSearchResults(forQuery: query,
                                                           sinceID: nil,
                                                           nextToken: nextToken)

        let newNextToken = searchResults.meta.next_token

        // Filter results to only contain tweets that reference the passed in tweet
        let filteredData = searchResults.data?.filter({ apiTweetData in
            apiTweetData.referenced_tweets?.contains { $0.id == id } ?? false
        })

        guard let data = filteredData, let users = searchResults.includes?.users else { return [] }

        for apiTweet in data {
            guard let apiUser = users.first(where: { $0.id == apiTweet.author_id }) else { return [] }
            replies.append(Tweet(api: api, apiTweetData: apiTweet, apiUser: apiUser))
        }

        if let nextToken = newNextToken {
            replies.append(contentsOf: try await getReplies(nextToken: nextToken))
        }

        return replies.reversed()
    }

    // TODO: get thread

}