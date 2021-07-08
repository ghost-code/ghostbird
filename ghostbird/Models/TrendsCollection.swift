//
//  TrendsCollection.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import Foundation

@MainActor
class TrendsCollection: ObservableObject {

    @Published var trendSearchResults: [SearchResults] = []

    let api: TwitterAPIProtocol

    init(api: TwitterAPIProtocol) {
        self.api = api
    }

    func updateTrends() async throws {

        let trendsResult = try await api.getTrends(for: "23424977").trends // USA

        var newTrends: [SearchResults] = []
        for i in 0..<trendsResult.count {
            newTrends.append(SearchResults(api: api, apiTrend: trendsResult[i]))
        }
        trendSearchResults = newTrends
    }

}
