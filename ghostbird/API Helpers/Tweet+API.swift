//
//  Tweet+API.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

extension Tweet.Metrics {
    init(apiTweetMetrics: TwitterAPI.Models.Tweet.Data.PublicMetrics) {
        self.init(retweetCount: apiTweetMetrics.retweet_count,
                  replyCount: apiTweetMetrics.reply_count,
                  likeCount: apiTweetMetrics.like_count,
                  quoteCount: apiTweetMetrics.quote_count)
    }
}

extension Tweet {

    convenience init(api: TwitterAPIProtocol,
         apiTweetData: TwitterAPI.Models.Tweet.Data,
         apiUser: TwitterAPI.Models.User.Data) {

        let twitterString = TwitterString(string: apiTweetData.text,
                                          entities: TwitterAPIWrapper.twitterStringEntities(for: apiTweetData),
                                          language: apiTweetData.lang)
        let entities = Tweet.entities(for: api, apiTweetData: apiTweetData)

        self.init(api: api,
                  id: apiTweetData.id,
                  text: apiTweetData.text,
                  twitterText: twitterString,
                  date: ISO8601DateFormatter.twitter.date(from: apiTweetData.created_at) ?? .now,
                  entities: entities,
                  author: User(api: api, apiUser: apiUser),
                  conversationID: apiTweetData.conversation_id,
                  hasReferencedTweets: !(apiTweetData.referenced_tweets?.isEmpty ?? true),
                  language: apiTweetData.lang,
                  referencedTweetIDs: apiTweetData.referenced_tweets?.map { $0.id },
                  metrics: Metrics.init(apiTweetMetrics: apiTweetData.public_metrics))
    }

    static func entities(for api: TwitterAPIProtocol,
                         apiTweetData: TwitterAPI.Models.Tweet.Data) -> Tweet.Entities {

        let cashtags = apiTweetData.entities?.cashtags?.map({
            Search(api: api, name: "$" + $0.tag, query: "$" + $0.tag)
        }) ?? []

        let hashtags = apiTweetData.entities?.hashtags?.map({
            Search(api: api, name: "#" + $0.tag, query: "#" + $0.tag)
        }) ?? []

//        let mentions = apiTweetData.entities?.mentions?.map({ _ in
////            User(api: TwitterAPIProtocol, apiUser: <#T##TwitterAPI.Models.User.Data#>)
//        }) ?? []
        let mentions: [User] = []

        let urls = apiTweetData.entities?.urls?.map({
            $0.url
        }) ?? []

        return Entities(cashtags: cashtags, hashtags: hashtags, mentions: mentions, urls: urls)
    }

    static func tweets(for apiTweets: TwitterAPI.Models.Tweets, api: TwitterAPIProtocol) -> [Tweet]? {
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
        let apiTweets = try await api.getTweets(forTweetIDs: ids)
        if let referencedTweets = Tweet.tweets(for: apiTweets, api: api) {
            for tweet in referencedTweets {
                tweets.insert(tweet, at: 0)
                let referencedTweetIDs = tweet.referencedTweetIDs
                tweets.insert(contentsOf: try await getReferencedTweets(for: referencedTweetIDs), at: 0)
            }
        }
        return tweets
    }

    // TODO: This destroys twitter api tweet caps on viral tweets and can be slow
    func getReplies(nextToken: String?, recursive: Bool) async throws -> [Tweet] {

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
            replies.insert(Tweet(api: api, apiTweetData: apiTweet, apiUser: apiUser), at: 0)
        }

        if recursive, let nextToken = newNextToken {
            replies.insert(contentsOf: try await getReplies(nextToken: nextToken, recursive: recursive), at: 0)
        }

        return replies
    }

    // TODO: get thread

}
