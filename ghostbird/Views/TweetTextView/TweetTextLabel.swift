//
//  TweetTextLabel.swift
//  TweetTextLabel
//
//  Created by David Russell on 8/2/21.
//

import UIKit

protocol TweetTextLabelDelegate: AnyObject {
    func didTapElement(element: TweetTextElement)
}

class TweetTextLabel: UIView, UIGestureRecognizerDelegate {

    weak var delegate: TweetTextLabelDelegate?
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: .zero)

    var preferredMaxLayoutWidth: CGFloat = 320 {
        didSet {
            textContainer.size = CGSize(width: preferredMaxLayoutWidth, height: .greatestFiniteMagnitude)
            setNeedsDisplay()
        }
    }

    override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    var textStorage: NSTextStorage? {
        didSet {
            textStorage?.addLayoutManager(layoutManager)
        }
    }

    var tweetText: TweetText? {
        didSet {
            if let attributedString = tweetText?.attributedString {
                textStorage = NSTextStorage(attributedString: attributedString)
            } else {
                textStorage = nil
            }
            setNeedsDisplay()
        }
    }

    init() {
        super.init(frame: .zero)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap(_:)))
        addGestureRecognizer(tapGesture)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        layoutManager.addTextContainer(textContainer)
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: preferredMaxLayoutWidth,
                      height: layoutManager.usedRect(for: textContainer).size.height)
    }

    override func draw(_ rect: CGRect) {
        let range = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawGlyphs(forGlyphRange: range, at: rect.origin)
    }

    @objc func didReceiveTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: gesture.view!)
        guard let result = element(at: location) else {
            return
        }

        didTapElement(element: result)
    }

    func didTapElement(element: TweetTextElement) {
        delegate?.didTapElement(element: element)
    }

    private func element(at point: CGPoint) -> TweetTextElement? {

        guard let tweetText = tweetText else { return nil }

        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        guard boundingRect.contains(point) else {
            return nil
        }

        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)

        return tweetText.elements.first { $0.range.contains(characterIndex) }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if element(at: point) != nil {
            return self
        } else {
            return nil
        }
    }
}
