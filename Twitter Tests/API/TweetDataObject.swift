//
//  TweetDataObject.swift
//  Twitter Tests
//
//  Created by David Russell on 7/3/21.
//

import Foundation

struct TweetDataObject: Identifiable, Decodable {
    let id: String
    let text: String
    let author_id: String
}
