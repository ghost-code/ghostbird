//
//  Search.swift
//  Search
//
//  Created by David Russell on 8/11/21.
//

import Foundation

@MainActor
class Search: ObservableObject, Identifiable {

    @Published var tweets: [Tweet] = []
    @Published var errorIsActive: Bool = false

    let api: TwitterAPIProtocol
    let id: String
    let name: String
    let query: String
    var olderTweetsToken: String?

    var activeError: Error? { didSet { errorIsActive = activeError != nil } }

    init(api: TwitterAPIProtocol, name: String, query: String) {
        self.api = api
        self.id = name
        self.name = name
        self.query = query
    }

}
