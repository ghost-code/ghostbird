//
//  TwitterClient.swift
//  ghostbird
//
//  Created by David Russell on 8/6/21.
//

import Foundation

class TwitterClient {

    typealias SearchResult = (tweets: [Tweet], nextToken: String?)

    let api: TwitterAPI
    static var shared = TwitterClient(api: TwitterAPI(keys: .init(key: TwitterKeys.key,
                                                                  secret: TwitterKeys.secret)))

    init(api: TwitterAPI) {
        self.api = api
    }

    static func tweetMetrics(for apiTweetMetrics: TwitterAPI.Models.Tweet.Data.PublicMetrics) -> Tweet.Metrics {
        Tweet.Metrics(retweetCount: apiTweetMetrics.retweet_count,
                      replyCount: apiTweetMetrics.reply_count,
                      likeCount: apiTweetMetrics.like_count,
                      quoteCount: apiTweetMetrics.quote_count)
    }


    static func twitterStringEntities(for apiTweetData: TwitterAPI.Models.Tweet.Data) -> [TwitterStringEntity] {

        var entities: [TwitterStringEntity] = []

        if let apiCashtags = apiTweetData.entities?.cashtags {
            apiCashtags.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .cashtag, range: range, string: "$" + $0.tag))
            }
        }

        if let apiHashtags = apiTweetData.entities?.hashtags {
            apiHashtags.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .hashtag, range: range, string: "#" + $0.tag))
            }
        }

        if let apiMentions = apiTweetData.entities?.mentions {
            apiMentions.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .mention, range: range, string: $0.username))
            }
        }

        if let apiURLs = apiTweetData.entities?.urls {
            apiURLs.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .url, range: range, string: $0.url.absoluteString)) // TODO: url?
            }
        }

        return entities
    }

    @MainActor
    static func tweet(for api: TwitterAPIProtocol,
               apiTweetData: TwitterAPI.Models.Tweet.Data,
               apiUser: TwitterAPI.Models.User.Data) -> Tweet {

        let twitterString = TwitterString(string: apiTweetData.text,
                                          entities: TwitterClient.twitterStringEntities(for: apiTweetData),
                                          language: apiTweetData.lang)
        let entities = TwitterClient.entities(for: api, apiTweetData: apiTweetData)

        let tweetMetrics = TwitterClient.tweetMetrics(for: apiTweetData.public_metrics)

        let tweet = Tweet(api: api,
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
                          metrics: tweetMetrics,
                          conversation: nil)

        let conversation = Conversation(tweet: tweet.copy)
        tweet.conversation = conversation

        return tweet
    }

    @MainActor
    static func tweets(for apiTweets: TwitterAPI.Models.Tweets, api: TwitterAPIProtocol) -> [Tweet]? {
        var tweets: [Tweet] = []
        let apiTweetsData = apiTweets.data
        for apiTweetData in apiTweetsData {
            if let apiUser = apiTweets.includes.users.first(where: { $0.id == apiTweetData.author_id }) {
                tweets.append(TwitterClient.tweet(for: api, apiTweetData: apiTweetData, apiUser: apiUser))
            }
        }
        return tweets.count > 0 ? tweets : nil
    }

    @MainActor
    static func entities(for api: TwitterAPIProtocol,
                         apiTweetData: TwitterAPI.Models.Tweet.Data) -> Tweet.Entities {

        let cashtags = apiTweetData.entities?.cashtags?.map({
            Search(api: api, name: "$" + $0.tag, query: "$" + $0.tag)
        }) ?? []

        let hashtags = apiTweetData.entities?.hashtags?.map({
            Search(api: api, name: "#" + $0.tag, query: "#" + $0.tag)
        }) ?? []

        let mentions: [User] = apiTweetData.entities?.mentions?.map({
            User(api: api, id: $0.id, userName: $0.username)
        }) ?? []

        let urls = apiTweetData.entities?.urls?.map({
            $0.url
        }) ?? []

        return Tweet.Entities(cashtags: cashtags, hashtags: hashtags, mentions: mentions, urls: urls)
    }

    func getReferencedTweets(for ids: [String]) async throws -> [Tweet] {
        var tweets: [Tweet] = []
        guard ids.count > 0 else { return tweets }
        let apiTweets = try await api.getTweets(forTweetIDs: ids)
        if let referencedTweets = await TwitterClient.tweets(for: apiTweets, api: api) {
            for tweet in referencedTweets {
                tweets.insert(tweet, at: 0)
                let referencedTweetIDs = tweet.referencedTweetIDs
                tweets.insert(contentsOf: try await getReferencedTweets(for: referencedTweetIDs), at: 0)
            }
        }
        return tweets
    }

    func getReplies(nextToken: String?,
                    conversationID: String,
                    username: String,
                    tweetID: String,
                    recursive: Bool) async throws -> SearchResult {

        var replies: [Tweet] = []
        let query = "conversation_id:" + conversationID + " to:" + username

        let searchResults = try await api.getSearchResults(forQuery: query,
                                                           sinceID: nil,
                                                           nextToken: nextToken)

        var newNextToken = searchResults.meta.next_token

        // Filter results to only contain tweets that reference the passed in tweet
        let filteredData = searchResults.data?.filter({ apiTweetData in
            apiTweetData.referenced_tweets?.contains { $0.id == tweetID } ?? false
        })

        guard let data = filteredData, let users = searchResults.includes?.users else { return ([], nil) }

        for apiTweet in data {
            guard let apiUser = users.first(where: { $0.id == apiTweet.author_id }) else { return ([], nil) }
            await replies.insert(TwitterClient.tweet(for: api, apiTweetData: apiTweet, apiUser: apiUser), at: 0)
        }

        if recursive, let nextToken = newNextToken {
            let moreReplies: [Tweet]
            (moreReplies, newNextToken) = try await getReplies(nextToken: nextToken,
                                                               conversationID: conversationID,
                                                               username: username,
                                                               tweetID: tweetID,
                                                               recursive: recursive)
            replies.insert(contentsOf: moreReplies, at: 0)
        }

        return (replies, newNextToken)
    }

    func getTrends(for woeid: Int) async throws -> [Trend] {
        let apiTrends = try await api.getTrends(for: woeid).trends
        var trends: [Trend] = []
        for i in 0..<apiTrends.count {
            await trends.append(Trend(api: api, apiTrend: apiTrends[i], position: i + 1))
        }
        return trends
    }

}
