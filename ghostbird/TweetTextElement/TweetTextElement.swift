//
//  TweetTextElement.swift
//  TweetTextElement
//
//  Created by David Russell on 8/2/21.
//

import Foundation

struct TweetTextElement {

    // TODO: remove string
    enum ElementType: String {
        case url, mention, hashtag
    }

    let string: String
    let range: NSRange
    let type: ElementType
}
