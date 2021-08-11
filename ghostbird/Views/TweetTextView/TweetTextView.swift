//
//  TweetTextView.swift
//  TweetTextView
//
//  Created by David Russell on 8/2/21.
//

import SwiftUI

struct TweetTextView: View {

    static private var lastKnownWidth: CGFloat = 320

    var twitterString: TwitterString
    @State var width: CGFloat = lastKnownWidth {
        didSet {
            TweetTextView.lastKnownWidth = width
        }
    }

    var twitterStringEntityTapAction: ((TwitterStringEntity) -> Void)?

    init(_ twitterString: TwitterString,
         twitterStringEntityTapAction: ((TwitterStringEntity) -> Void)?) {
        self.twitterString = twitterString
        self.twitterStringEntityTapAction = twitterStringEntityTapAction
    }

    var body: some View {
        RepresentedTweetTextLabel(twitterString: twitterString,
                                  width: width,
                                  twitterStringEntityTapAction: {
            twitterStringEntityTapAction?($0)

        })
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                GeometryReader {
                Color.clear
                    .preference(key: ViewWidthKey.self,
                        value: $0.frame(in: .local).size.width)
            })
            .onPreferenceChange(ViewWidthKey.self) { self.width = $0 }
    }
}

struct ViewWidthKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct RepresentedTweetTextLabel: UIViewRepresentable {

    let twitterString: TwitterString
    var width: CGFloat

    var twitterStringEntityTapAction: ((TwitterStringEntity) -> Void)?

    func makeUIView(context: Context) -> TweetTextLabel {
        let tweetTextView = TweetTextLabel()

        // TODO: Investigate if all of these are necessary
        tweetTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tweetTextView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        tweetTextView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tweetTextView.setContentHuggingPriority(.defaultLow, for: .vertical)

        return tweetTextView
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.twitterStringEntityTapAction = twitterStringEntityTapAction
        return coordinator
    }

    func updateUIView(_ uiView: TweetTextLabel, context: Context) {
        uiView.twitterString = twitterString
        uiView.preferredMaxLayoutWidth = width
        uiView.delegate = context.coordinator
    }

}

extension RepresentedTweetTextLabel {

    class Coordinator: TweetTextLabelDelegate {

        var twitterStringEntityTapAction: ((TwitterStringEntity) -> Void)?

        func didTapEntity(_ entity: TwitterStringEntity) {
            twitterStringEntityTapAction?(entity)
        }

    }

}
