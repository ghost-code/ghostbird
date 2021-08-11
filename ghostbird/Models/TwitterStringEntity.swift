//
//  TwitterStringEntity.swift
//  TwitterStringEntity
//
//  Created by David Russell on 8/11/21.
//

import Foundation

struct TwitterStringEntity {

    enum EntityType {
        case cashtag, hashtag, mention, url
    }

    var type: EntityType
    var range: NSRange
    var string: String

}
