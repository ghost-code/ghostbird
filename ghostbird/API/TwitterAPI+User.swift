//
//  TwitterAPI+User.swift
//  ghostbird
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

//    func getUser(with id: String?) async throws -> TwitterAPI.Models.Trends {
//        var queryItems: [URLQueryItem] = []
//
//        queryItems.append(.init(name: "id", value: locationID ?? "1"))
//
//        return try await performRequest(method: .get,
//                                        path: "2/users/" + id,
//                                        queryItems: queryItems)
//    }
}

extension TwitterAPI.Models {

    struct User: Decodable {
        let data: Data
        let includes: Includes

        struct Data: Decodable {
            let username: String
            let created_at: String?
            let pinned_tweet_id: String?
            let profile_image_url: URL?
            let id: String
            let name: String
        }

        struct Includes: Decodable {
            let tweets: [Tweet.Data]
        }
    }
    
}
