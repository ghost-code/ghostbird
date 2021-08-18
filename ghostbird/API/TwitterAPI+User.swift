//
//  TwitterAPI+User.swift
//  ghostbird
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

    func getUser(with id: String) async throws -> TwitterAPI.Models.User {
        var queryItems: [URLQueryItem] = []

        queryItems.append(TwitterAPI.QueryItems.userFields)
        queryItems.append(TwitterAPI.QueryItems.tweetFields)

        return try await performRequest(method: .get,
                                        path: "/2/users/" + id,
                                        queryItems: queryItems)
    }

}

extension TwitterAPI.Models {

    struct User: Decodable {
        let data: Data

        struct Data: Decodable {
            let created_at: String
            let description: String
            let id: String
            let location: String?
            let pinned_tweet_id: String?
            let profile_image_url: URL?
            let username: String
            let name: String
            let public_metrics: PublicMetrics
            let url: String
            let verified: Bool
            // let withheld ... not sure how this comes down yet

            struct PublicMetrics: Decodable {
                let followers_count: Int
                let following_count: Int
                let tweet_count: Int
                let listed_count: Int
            }
        }

    }
    
}
