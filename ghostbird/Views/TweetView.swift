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
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    nameView
                    Spacer()
                    dateView
                        .fixedSize()
                }
                Spacer().frame(height: 4)
                textView
                Spacer().frame(height: 8)
                metricsView
            }
            hiddenNavigationLink
        }
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 4))
        .overlay(Color("SeparatorColor").frame(height: 0.5), alignment: .bottom)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(Color.gray)
        }
        .frame(width: 40, height: 40)
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
            metricView(with: Image(systemName: tweet.hasReferencedTweets ?
                                   "bubble.left.and.bubble.right" : "bubble.right"),
                       count: tweet.metrics.replyCount)
            metricView(with: Image(systemName: "arrow.2.squarepath"),
                       count: tweet.metrics.retweetCount)
            metricView(with: Image(systemName: "heart"),
                       count: tweet.metrics.likeCount)
        }
        .padding(.trailing, 8)
    }

    func metricView(with image: Image, count: Int) -> some View {
        HStack(spacing: 4) {
            image
            Text("\(count)")
        }
        .font(Font.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var hiddenNavigationLink: some View {
        NavigationLink(destination: ConversationView(tweet: tweet)) {
            EmptyView()
        }
        .opacity(0)
        .frame(width: 0)
    }

}
