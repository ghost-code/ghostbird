//
//  Tweet.swift
//  Twitter Tests
//
//  Created by David Russell on 7/2/21.
//

import Foundation

struct Tweet: Identifiable {
    let id: String
    let text: String
    let author: User

    init(tweetDataObject: TweetDataObject, userDataObject: UserDataObject) {
        self.id = tweetDataObject.id
        self.text = tweetDataObject.text
        self.author = User(userDataObject: userDataObject)
    }
}
