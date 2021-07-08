//
//  TwitterAPI+Trends.swift
//  ghostbird
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension TwitterAPI {

    func getTrends(for locationID: String?) async throws -> TwitterAPI.Models.Trends {
        var queryItems: [URLQueryItem] = []

        queryItems.append(.init(name: "id", value: locationID ?? "1"))

        return try await performRequest(method: .get,
                                        path: "/1.1/trends/place.json",
                                        queryItems: queryItems)
    }
}

extension TwitterAPI.Models {

    struct Trends: Decodable {
        let trends: [Trend]
        let creationDate: Date?
        let lastUpdate: Date?
        let locations: [Location]

        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let trendObject = try container.decode(TrendsResponseObject.self)

            self.trends = trendObject.trends
            let dateFormatter = ISO8601DateFormatter()
            self.creationDate = dateFormatter.date(from: trendObject.created_at)
            self.lastUpdate = dateFormatter.date(from: trendObject.as_of)
            self.locations = trendObject.locations
        }

        private struct TrendsResponseObject: Decodable {
            let trends: [Trend]
            let as_of: String
            let created_at: String
            let locations: [Location]
        }

        struct Location: Decodable {
            let name: String
            let woeid: Int
        }
    }

    struct Trend: Decodable {
        let name: String
        let url: URL
        let query: String
        let tweet_volume: Int?
    }

}
