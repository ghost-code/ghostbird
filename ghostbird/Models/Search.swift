//
//  Search.swift
//  ghostbird
//
//  Created by David Russell on 8/11/21.
//

import Foundation

@MainActor
class Search: ObservableObject, Identifiable {

    @Published var tweets: [Tweet] = []
    @Published var errorIsActive: Bool = false

    let id: String
    let name: String
    let query: String
    var observableError = ObservableError()
    var searchActor: SearchActor

    init(name: String, query: String) {
        self.id = name
        self.name = name
        self.query = query
        self.searchActor = SearchActor(query: query)
    }

    func getTweets() async {
        do {
            tweets = try await searchActor.getTweets()
        } catch {
            observableError.activeError = error
        }
    }

    func getNewerTweets() async {
        do {
            tweets.insert(contentsOf: try await searchActor.getNewerTweets(), at: 0)
        } catch {
            observableError.activeError = error
        }
    }

    func getOlderTweets() async {
        do {
            tweets.append(contentsOf: try await searchActor.getOlderTweets())
        } catch {
            observableError.activeError = error
        }
    }

}
