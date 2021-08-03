//
//  TweetTextView.swift
//  TweetTextView
//
//  Created by David Russell on 8/2/21.
//

import SwiftUI

struct TweetTextView: View {

    var tweetText: TweetText
    @State var width: CGFloat = 320

    init(_ tweetText: TweetText) {
        self.tweetText = tweetText
    }

    var body: some View {
        RepresentedTweetTextLabel(tweetText: tweetText, width: width)
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

    let tweetText: TweetText
    var width: CGFloat

    func makeUIView(context: Context) -> TweetTextLabel {
        let tweetTextView = TweetTextLabel()

        // TODO: Investigate if all of these are necessary
        tweetTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tweetTextView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        tweetTextView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tweetTextView.setContentHuggingPriority(.defaultLow, for: .vertical)

        return tweetTextView
    }


    func updateUIView(_ uiView: TweetTextLabel, context: Context) {
        uiView.tweetText = tweetText
        uiView.preferredMaxLayoutWidth = width
    }

}
