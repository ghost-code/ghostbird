//
//  Trends.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

@MainActor
class Trends: ObservableObject {

    @Published var trendsCollection: [Trend] = []

    let woeid: Int
    let api: TwitterAPIProtocol

    init(api: TwitterAPIProtocol, woeid: Int) {
        self.api = api
        self.woeid = woeid
    }

    func getTrends() async throws {
        let apiTrends = try await api.getTrends(for: woeid).trends
        var trends: [Trend] = []
        for i in 0..<apiTrends.count {
            trends.append(Trend(api: api, apiTrend: apiTrends[i], position: i + 1))
        }
        trendsCollection = trends
    }
    
}
