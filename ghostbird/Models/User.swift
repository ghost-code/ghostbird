//
//  Pofile.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import Foundation

@MainActor
class User: ObservableObject, Identifiable {

    let id: String
    let username: String

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
    @Published var mentions: [Tweet] = []


    var observableError = ObservableError()
    let userActor: UserActor

    var isLoaded: Bool {
        return name != nil
    }

    init(id: String,
         username: String,
         name: String? = nil,
         createdAt: Date? = nil,
         description: String? = nil,
         location: String? = nil,
         pinnedTweetID: String? = nil,
         profileImageURL: URL? = nil,
         publicMetrics: PublicMetrics? = nil,
         url: URL? = nil,
         verified: Bool? = nil) {
        self.id = id
        self.username = username
        self.name = name
        self.createdAt = createdAt
        self.description = description
        self.location = location
        self.pinnedTweetID = pinnedTweetID
        self.profileImageURL = profileImageURL
        self.publicMetrics = publicMetrics
        self.url = url
        self.verified = verified
        self.userActor = UserActor(userID: id)
    }

    private func update(with user: User) {
        self.name = user.name
        self.createdAt = user.createdAt
        self.description = user.description
        self.location = user.location
        self.pinnedTweetID = user.pinnedTweetID
        self.profileImageURL = user.profileImageURL
        self.publicMetrics = user.publicMetrics
        self.url = user.url
        self.verified = user.verified
    }

    func getUser() async {
        do {
            update(with: try await userActor.getUser())
        } catch {
            observableError.activeError = error
        }
    }

    func getMentions() async {
        do {
            mentions = try await userActor.getMentions()
        } catch {
            observableError.activeError = error
        }
    }

    func getTweets() async {
        do {
            tweets = try await userActor.getTweets()
        } catch {
            observableError.activeError = error
        }
    }

    func getNewerTweets() async {
        do {
            tweets.insert(contentsOf: try await userActor.getNewerTweets(), at: 0)
        } catch {
            observableError.activeError = error
        }
    }

    func getOlderTweets() async {
        do {
            tweets.append(contentsOf: try await userActor.getNewerTweets())
        } catch {
            observableError.activeError = error
        }
    }

}

extension User {

    struct PublicMetrics {
        let followersCount: Int
        let followingCount: Int
        let tweetCount: Int
        let listedCount: Int
    }

}
