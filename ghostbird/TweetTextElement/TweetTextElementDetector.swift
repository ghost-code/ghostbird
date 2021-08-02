//
//  TweetElementDetector.swift
//  TweetElementDetector
//
//  Created by David Russell on 8/2/21.
//

import Foundation

class TweetTextElementDetector {

    let mentionDetector = NSRegularExpression.tweetMention
    let hashtagDetector = NSRegularExpression.tweetHashtag

    // TODO: swap this out to prevent hashtag collisions
    let urlDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

    func elements(for string: String) -> [TweetTextElement] {
        var elements: [TweetTextElement] = []

        let nsString = NSString(string: string)
        let range = NSRange(location: 0, length: nsString.length)
        let mentions = mentionDetector.matches(in: string, options: [], range: range)
        let hashtags = hashtagDetector.matches(in: string, options: [], range: range)
        let urls = urlDetector.matches(in: string, options: [], range: range)

        elements.append(contentsOf: mentions.map {
            TweetTextElement(string: String(string[Range($0.range, in: string)!]),
                         range: $0.range,
                         type: .mention)
        })

        elements.append(contentsOf: hashtags.map {
            TweetTextElement(string: String(string[Range($0.range, in: string)!]),
                         range: $0.range,
                         type: .hashtag)
        })

        elements.append(contentsOf: urls.map {
            TweetTextElement(string: String(string[Range($0.range, in: string)!]),
                         range: $0.range,
                         type: .url)
        })

        return elements
    }
}
