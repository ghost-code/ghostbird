//
//  Trend.swift
//  ghostbird
//
//  Created by David Russell on 7/7/21.
//

import Foundation

@MainActor
class Trend: Identifiable {

    var api: TwitterAPIProtocol
    let id: String
    let name: String
    let position: Int
    let tweetVolume: Int?
    let searchResults: SearchResults

    init(api: TwitterAPIProtocol,
         name: String,
         query: String,
         position: Int,
         tweetVolume: Int?) {
        self.api = api
        self.id = name
        self.name = name
        self.position = position
        self.tweetVolume = tweetVolume
        self.searchResults = SearchResults(api: api,
                                           id: name,
                                           name: name,
                                           query: query)
    }
    
}