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
    var observableError = ObservableError()
    private let trendsActor = TrendsActor()

    init(woeid: Int) {
        self.woeid = woeid
    }

    func getTrends() async {
        do {
            trendsCollection = try await trendsActor.getTrends(for: woeid)
        } catch {
            observableError.activeError = error
        }
    }
    
}

@MainActor
class Trend: Identifiable {

    let id: String
    let name: String
    let position: Int
    let tweetVolume: Int?
    let search: Search

    init(name: String,
         query: String,
         position: Int,
         tweetVolume: Int?) {
        self.id = name
        self.name = name
        self.position = position
        self.tweetVolume = tweetVolume
        self.search = Search(name: name,
                             query: query)
    }

}
