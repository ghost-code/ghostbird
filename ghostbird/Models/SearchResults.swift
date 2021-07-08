//
//  SearchResults.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import Foundation

@MainActor
class SearchResults: ObservableObject, Identifiable {

    @Published var tweets: [Tweet] = []
    @Published var errorIsActive: Bool = false

    let api: TwitterAPIProtocol
    let id: String
    let name: String
    let query: String
    var olderTweetsToken: String?

    var activeError: Error? { didSet { errorIsActive = activeError != nil } }

    init(api: TwitterAPIProtocol, id: String, name: String, query: String) {
        self.api = api
        self.id = id
        self.name = name
        self.query = query
    }

}
