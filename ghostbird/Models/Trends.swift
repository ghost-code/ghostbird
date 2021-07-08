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
    @Published var errorIsActive: Bool = false

    let woeid: Int
    let api: TwitterAPIProtocol

    var activeError: Error? { didSet { errorIsActive = activeError != nil } }

    init(api: TwitterAPIProtocol, woeid: Int) {
        self.api = api
        self.woeid = woeid
    }

    func getTrends() async {
        do {
            let apiTrends = try await api.getTrends(for: woeid).trends
            var trends: [Trend] = []
            for i in 0..<apiTrends.count {
                trends.append(Trend(api: api, apiTrend: apiTrends[i], position: i + 1))
            }
            trendsCollection = trends
        } catch {
            self.activeError = error
        }
    }
    
}
