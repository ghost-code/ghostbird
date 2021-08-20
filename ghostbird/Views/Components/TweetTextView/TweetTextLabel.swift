//
//  TweetTextLabel.swift
//  TweetTextLabel
//
//  Created by David Russell on 8/2/21.
//

import UIKit

protocol TweetTextLabelDelegate: AnyObject {
    func didTapEntity(_ entity: TwitterStringEntity)
}

class TweetTextLabel: UIView, UIGestureRecognizerDelegate {

    static let heightCalculator = TweetTextLabelHeightCalculator()

    weak var delegate: TweetTextLabelDelegate?
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: .zero)
    var tappedEntity: TwitterStringEntity? = nil {
        didSet {
            setNeedsDisplay()
        }
    }

    var preferredMaxLayoutWidth: CGFloat = 320 {
        didSet {
            textContainer.size = CGSize(width: preferredMaxLayoutWidth, height: .greatestFiniteMagnitude)
            invalidateIntrinsicContentSize()
        }
    }

    var textStorage: NSTextStorage? {
        didSet {
            textStorage?.addLayoutManager(layoutManager)
        }
    }

    var twitterString: TwitterString? {
        didSet {
            if let attributedString = twitterString?.attributedString {
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

        if let element = tappedEntity {
            for i in element.range.lowerBound..<element.range.upperBound {
                let rect = layoutManager.boundingRect(forGlyphRange: NSRange(location: i, length: 1),
                                                      in: textContainer)
                    let context = UIGraphicsGetCurrentContext()
                    UIColor.init(white: 0.5, alpha: 0.27).set()
                    context?.addRect(rect)
                    context?.fillPath()
            }

        }

        layoutManager.drawGlyphs(forGlyphRange: range, at: rect.origin)
    }

    @objc func didReceiveTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: gesture.view!)
        guard let entity = entity(at: location) else { return }
        delegate?.didTapEntity(entity)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        tappedEntity = entity(at: touches.first!.location(in: self))
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        tappedEntity = nil
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tappedEntity = nil
    }

    private func entity(at point: CGPoint) -> TwitterStringEntity? {

        guard let twitterString = twitterString else { return nil }

        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        guard boundingRect.contains(point) else {
            return nil
        }

        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        return twitterString.entities.first { $0.range.contains(characterIndex) }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if entity(at: point) != nil {
            return self
        } else {
            return nil
        }
    }

}

struct TweetTextLabelHeightCalculator {

    let layoutManager: NSLayoutManager = NSLayoutManager()
    let textContainer: NSTextContainer = NSTextContainer()

    init() {
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        layoutManager.addTextContainer(textContainer)
    }

    func height(for attributedString: NSAttributedString, width: CGFloat) -> CGFloat {
        // Add attributed string to container
        return CGSize(width: width,
                      height: layoutManager.usedRect(for: textContainer).size.height).height
    }

}
