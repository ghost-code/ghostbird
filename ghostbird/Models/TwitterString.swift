//
//  TextEntity.swift
//  TextEntity
//
//  Created by David Russell on 8/6/21.
//

import SwiftUI

struct TwitterString {

    let entities: [TwitterStringEntity]
    let string: String
    let attributedString: NSAttributedString

    private let font: UIFont = UIFont.systemFont(ofSize: 16)
    private let elementColor = UIColor(.accentColor)

    static let detector = TweetTextElementDetector()

    init(string: String, entities: [TwitterStringEntity], language: String?) {
        let isLTR: Bool
        if let language = language {
            isLTR =  NSLocale.characterDirection(forLanguage: language) == .leftToRight
        } else {
            isLTR = true
        }

        self.string = string
        self.entities = entities
        self.attributedString = TwitterString.attributedString(for: string,
                                                                  entities: entities,
                                                                  font: font,
                                                                  elementColor: elementColor,
                                                                  isLTR: isLTR)
    }

    static func attributedString(for text: String,
                                 entities: [TwitterStringEntity],
                                 font: UIFont,
                                 elementColor: UIColor,
                                 isLTR: Bool) -> NSAttributedString {

        let text = text + "\u{0000}"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = isLTR ? .left : .right
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes = [ NSAttributedString.Key.paragraphStyle: paragraphStyle,
                           NSAttributedString.Key.foregroundColor: UIColor.label,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) ]

        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)

        for entity in entities {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor(named: "AccentColor")!,
                                          range: entity.range)
        }

        return attributedString
    }

}
