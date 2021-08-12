//
//  User+API.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

extension User {

    func getUser() async {
        do {
            let apiUser = try await api.getUser(with: id).data
            self.name = apiUser.name
            self.createdAt = ISO8601DateFormatter.twitter.date(from: apiUser.created_at) ?? .now
            self.description = apiUser.description
            self.location = apiUser.location
            self.pinnedTweetID = apiUser.pinned_tweet_id
            self.profileImageURL = apiUser.profile_image_url
            self.publicMetrics = PublicMetrics(apiUser.public_metrics)
            self.url = URL(string: apiUser.url)
            self.verified = apiUser.verified
        } catch {
            activeError = error
            print(error)
            errorIsActive = true
        }
    }

    func getTweets() async {
        do {
            let searchResults = try await api.getTweets(forUserID: id, nextToken: nil)
            olderTweetsToken = searchResults.meta.next_token
            self.tweets = Search.tweets(for: searchResults, api: api)
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

    func getOlderTweets() async {
        do {
            let searchResults = try await api.getTweets(forUserID: id, nextToken: olderTweetsToken)
            self.olderTweetsToken = searchResults.meta.next_token
            tweets.append(contentsOf: Search.tweets(for: searchResults, api: api))
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

}
