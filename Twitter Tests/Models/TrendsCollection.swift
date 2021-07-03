//
//  TrendsCollection.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import Foundation

@MainActor
class TrendsCollection: ObservableObject {

    @Published var trends: [Trend] = []

    let api: TwitterAPIProtocol

    init(api: TwitterAPIProtocol) {
        self.api = api
    }

    func updateTrends() async throws {

        let trendsResult = try await api.getTrends(for: "23424977").trends

        var newTrends: [Trend] = []
        for i in 0..<trendsResult.count {
            newTrends.append(Trend(api: api, trendDataObject: trendsResult[i], position: i + 1))
        }
        trends = newTrends
    }
}
