//
//  User+API.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

extension User {

    func getTweets() async {
        do {
            let searchResults = try await api.getTweets(forUserID: id, nextToken: nil)
            olderTweetsToken = searchResults.meta.next_token
            self.tweets = SearchResults.tweets(for: searchResults, api: api)
        } catch {
            print(error)
            activeError = error
            errorIsActive = true
        }
    }

    func getOlderTweets() async {
        do {
            let searchResults = try await api.getTweets(forUserID: id, nextToken: olderTweetsToken)
            self.olderTweetsToken = searchResults.meta.next_token
            tweets.append(contentsOf: SearchResults.tweets(for: searchResults, api: api))
        } catch {
            activeError = error
            errorIsActive = true
        }
    }

}
