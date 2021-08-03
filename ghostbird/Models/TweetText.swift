//
//  TweetText.swift
//  TweetText
//
//  Created by David Russell on 8/2/21.
//

import SwiftUI

struct TweetText {

    let string: String
    let attributedString: NSAttributedString
    let elements: [TweetTextElement]

    static let detector = TweetTextElementDetector()

    private let font: UIFont = UIFont.systemFont(ofSize: 16)
    private let elementColor = UIColor(.accentColor)

    static var elementColor: Color = .accentColor
    static var font: Font = .headline

    init(string: String) {
        self.string = string
        let elements = TweetText.detector.elements(for: string)
        self.elements = elements
        self.attributedString = TweetText.attributedString(for: string,
                                                              tweetTextElements: elements,
                                                              font: font,
                                                              elementColor: elementColor)
    }

    static func attributedString(for text: String,
                                 tweetTextElements: [TweetTextElement],
                                 font: UIFont,
                                 elementColor: UIColor) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes = [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ]

        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)

        for element in tweetTextElements {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor(TweetText.elementColor),
                                          range: element.range)
        }

        return NSAttributedString(attributedString: attributedString)
    }


// Hopefully this works in the future
//    static func attributedString(for text: String,
//                                 tweetTextElements: [TweetTextElement],
//                                 font: UIFont,
//                                 elementColor: UIColor) -> AttributedString {
//
//        var attributedString1 = AttributedString(text)
//
//        for element in tweetTextElements {
//
//            if let low = AttributedString.Index(String.Index(utf16Offset: element.range.lowerBound, in: text), within: attributedString1), let high = AttributedString.Index(String.Index(utf16Offset: element.range.upperBound, in: text), within: attributedString1) {
//                attributedString1[low..<high].foregroundColor = .blue
//            }
//        }
//
//        attributedString1.font = TweetText.font
//        return attributedString1
//    }
}

extension TweetText {
    struct Element {
        // TODO: remove string
        enum ElementType: String {
            case url, mention, hashtag
        }

        let string: String
        let range: NSRange
        let type: ElementType
    }
}
