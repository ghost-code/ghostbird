//
//  TweetView.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import SwiftUI

struct TweetView: View {

    @Environment(\.openURL) var openURL

    @ObservedObject var tweet: Tweet

    // TODO: clean this up
    var elementDestination: some View {
        guard let entity = tweet.activeEntity else { return AnyView(ConversationView(tweet: tweet.copy)) }
        switch entity.type {
        case .cashtag:
            if let search = tweet.cashtagSearch(for: entity) {
                return AnyView(SearchView(search: search))
            }
        case .hashtag:
            if let search = tweet.hashtagSearch(for: entity) {
                return AnyView(SearchView(search: search))
            }
        case .mention:
            if let user = tweet.user(for: entity) {
                return AnyView(UserView(user: user))
            }
        default:
            return AnyView(Text(entity.string))
        }

        return AnyView(EmptyView())
    }

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
                tweetTextView
                Spacer().frame(height: 8)
                metricsView
            }
            hiddenNavigationLink
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 4))
        .overlay(Color("SeparatorColor").frame(height: 0.5), alignment: .bottom)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    var userImage: some View {
        AsyncImage(url: tweet.author.profileImageURL) { image in
            image
                .resizable()
                .clipShape(Circle())
        } placeholder: {
            Circle()
                .fill(Color.gray)
        }
            .frame(width: 40, height: 40)
        .onTapGesture {
            tweet.activeEntity = TwitterStringEntity(type: .mention,
                                                     range: NSRange(location: 0, length: 0),
                                                     string: tweet.author.userName)
        }
    }

    var nameView: some View {
        HStack(spacing: 4) {
            Text(tweet.author.name ?? "")
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

    var tweetTextView: some View {
        TweetTextView(tweet.twitterText,
                      twitterStringEntityTapAction: { entity in
            if entity.type == .url {
                guard let url = URL(string: entity.string) else { return }
                openURL(url)
            } else {
                tweet.activeEntity = entity
            }
        })
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
        NavigationLink(destination: elementDestination,
                       isActive: $tweet.entityIsActive) {
            EmptyView()
        }
        .opacity(0)
        .frame(width: 0)
    }

}
