//
//  TwitterAPIWrapper.swift
//  TwitterAPIWrapper
//
//  Created by David Russell on 8/6/21.
//

import Foundation

class TwitterAPIWrapper {

    static func twitterStringEntities(for apiTweetData: TwitterAPI.Models.Tweet.Data) -> [TwitterStringEntity] {

        var entities: [TwitterStringEntity] = []

        if let apiCashtags = apiTweetData.entities?.cashtags {
            apiCashtags.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .cashtag, range: range, string: "$" + $0.tag))
            }
        }

        if let apiHashtags = apiTweetData.entities?.hashtags {
            apiHashtags.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .hashtag, range: range, string: "#" + $0.tag))
            }
        }

        if let apiMentions = apiTweetData.entities?.mentions {
            apiMentions.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .mention, range: range, string: $0.username))
            }
        }

        if let apiURLs = apiTweetData.entities?.urls {
            apiURLs.forEach {
                let range = NSRange(location: $0.start, length: $0.end - $0.start)
                entities.append(TwitterStringEntity(type: .url, range: range, string: $0.url.absoluteString)) // TODO: url?
            }
        }

        return entities
    }

}
