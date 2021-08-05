//
//  Pofile.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import Foundation

class User: ObservableObject, Identifiable {

    let id: String
    let name: String
    let userName: String
    let createdAt: Date
    let description: String
    let location: String?
    let pinnedTweetID: String?
    let profileImageURL: URL?
    let publicMetrics: PublicMetrics
    let url: URL?
    let verified: Bool

    @Published var tweets: [Tweet] = []

    init(apiUser: TwitterAPI.Models.User.Data) {
        self.id = apiUser.id
        self.name = apiUser.name
        self.userName = apiUser.username
        self.createdAt = ISO8601DateFormatter.twitter.date(from: apiUser.created_at) ?? .now
        self.description = apiUser.description
        self.location = apiUser.location
        self.pinnedTweetID = apiUser.pinned_tweet_id
        self.profileImageURL = apiUser.profile_image_url
        self.publicMetrics = PublicMetrics(apiUser.public_metrics)
        self.url = URL(string: apiUser.url)
        self.verified = apiUser.verified
    }

}

extension User {

    struct PublicMetrics {

        let followersCount: Int
        let followingCount: Int
        let tweetCount: Int
        let listedCount: Int

        init(_ apiUserMetrics: TwitterAPI.Models.User.Data.PublicMetrics) {
            self.followersCount = apiUserMetrics.followers_count
            self.followingCount = apiUserMetrics.following_count
            self.tweetCount = apiUserMetrics.tweet_count
            self.listedCount = apiUserMetrics.listed_count
        }

    }

}
