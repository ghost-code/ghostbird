//
//  SearchResponse.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import Foundation

struct SearchResponse: Decodable {

    let data: [TweetDataObject]
    let meta: SearchResponseMeta
    let includes: SearchResponseIncludes

    struct SearchResponseMeta: Decodable {
        let newest_id: String
        let oldest_id: String
        let result_count: Int
        let next_token: String
    }

    struct SearchResponseIncludes: Decodable {
        let users: [UserDataObject]
    }
}
