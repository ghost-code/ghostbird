//
//  Pofile.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import Foundation

@MainActor
class User: ObservableObject, Identifiable {

    let api: TwitterAPIProtocol
    let id: String
    let userName: String

    @Published var name: String?
    @Published var createdAt: Date?
    @Published var description: String?
    @Published var location: String?
    @Published var pinnedTweetID: String?
    @Published var profileImageURL: URL?
    @Published var publicMetrics: PublicMetrics?
    @Published var url: URL?
    @Published var verified: Bool?
    @Published var tweets: [Tweet] = []

    var olderTweetsToken: String?

    @Published var errorIsActive: Bool = false {
        didSet {
            if !errorIsActive && activeError != nil {
                activeError = nil
            }
        }
    }

    var activeError: Error? {
        didSet {
            errorIsActive = activeError != nil

        }
    }

    var isLoaded: Bool {
        return name != nil
    }

    init(api: TwitterAPIProtocol, apiUser: TwitterAPI.Models.User.Data) {
        self.api = api
        self.id = apiUser.id
        self.userName = apiUser.username
        self.name = apiUser.name
        self.createdAt = ISO8601DateFormatter.twitter.date(from: apiUser.created_at) ?? .now
        self.description = apiUser.description
        self.location = apiUser.location
        self.pinnedTweetID = apiUser.pinned_tweet_id
        self.profileImageURL = apiUser.profile_image_url
        self.publicMetrics = PublicMetrics(apiUser.public_metrics)
        self.url = URL(string: apiUser.url)
        self.verified = apiUser.verified
    }

    init(api: TwitterAPIProtocol,
         id: String,
         userName: String,
         name: String? = nil,
         createdAt: Date? = nil,
         description: String? = nil,
         location: String? = nil,
         pinnedTweetID: String? = nil,
         profileImageURL: URL? = nil,
         publicMetrics: PublicMetrics? = nil,
         url: URL? = nil,
         verified: Bool? = nil) {
        self.api = api
        self.id = id
        self.userName = userName
        self.name = name
        self.createdAt = createdAt
        self.description = description
        self.location = location
        self.pinnedTweetID = pinnedTweetID
        self.profileImageURL = profileImageURL
        self.publicMetrics = publicMetrics
        self.url = url
        self.verified = verified
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
