//
//  TrendsResponse.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import Foundation

struct TrendsResponse {
    let trends: [TrendDataObject]
    let creationDate: Date?
    let lastUpdate: Date?
    let locations: [TrendsDataObject.Location]
}

extension TrendsResponse: Decodable {

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let trendObject = try container.decode(TrendsDataObject.self)

        self.trends = trendObject.trends
        let dateFormatter = ISO8601DateFormatter()
        self.creationDate = dateFormatter.date(from: trendObject.created_at)
        self.lastUpdate = dateFormatter.date(from: trendObject.as_of)
        self.locations = trendObject.locations
    }
}

struct TrendsDataObject: Decodable {
    let trends: [TrendDataObject]
    let as_of: String
    let created_at: String
    let locations: [Location]

    struct Location: Decodable {
        let name: String
        let woeid: Int
    }
}

struct TrendDataObject: Decodable {
    let name: String
    let url: URL
    let query: String
    let tweetVolume: Int?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
        case query = "query"
        case tweetVolume = "tweet_volume"
    }
}
