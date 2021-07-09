//
//  TweetView.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import SwiftUI

struct TweetView: View {

    @ObservedObject var tweet: Tweet

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            userImage

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    nameView
                    Spacer()
                    dateView
                        .fixedSize()
                }
                textView
                metricsView
            }
        }
        .padding(4)
    }

    var textView: some View {
        Text(tweet.text)
            .font(.caption)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var userImage: some View {
        AsyncImage(url: tweet.author.imageURL) { image in
            image
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(Color.gray)
                .frame(width: 32, height: 32)
        }
    }

    var nameView: some View {
        HStack(spacing: 4) {
            Text(tweet.author.name)
                .font(.caption)
                .bold()
                .lineLimit(1)
            Text("@" + tweet.author.userName)
                .font(.caption2)
                .lineLimit(1)
        }
    }

    var dateView: some View {
        Text(tweet.date.agoString)
            .font(.caption2)
            .lineLimit(1)
    }

    var metricsView: some View {

        HStack {
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                Text("\(tweet.metrics.replyCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Image(systemName: "arrow.2.squarepath")
                Text("\(tweet.metrics.retweetCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Image(systemName: "heart")
                Text("\(tweet.metrics.likeCount)")
            }

            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(Font.caption.weight(.semibold))
    }

}
