//
//  RegularExpression+Twitter.swift
//  RegularExpression+Twitter
//
//  Created by David Russell on 8/2/21.
//

import Foundation

extension NSRegularExpression {
    static var tweetMention: NSRegularExpression {
        let pattern = "(?<=^|(?<=[^a-zA-Z0-9-_.]))@([A-Za-z_]+[A-Za-z0-9_]+)"
        return try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }

    static var tweetHashtag: NSRegularExpression {
        let alpha = "[\\p{L}\\p{M}]"
        let specialChars = "_\\u200c\\u200d\\ua67e\\u05be\\u05f3\\u05f4\\uff5e\\u301c\\u309b\\u309c"
            + "\\u30a0\\u30fb\\u3003\\u0f0b\\u0f0c\\u00b7"
        let alphanumeric = "[\\p{L}\\p{M}\\p{Nd}" + specialChars + "]"
        let pattern = "(?:)([#＃](?!\u{fe0f}|\u{20e3})"
            + alphanumeric + "*" + alpha + alphanumeric + "*)"

        return try! NSRegularExpression(pattern: pattern, options: [])
    }
}
