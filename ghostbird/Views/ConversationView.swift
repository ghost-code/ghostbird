//
//  ConversationView.swift
//  ghostbird
//
//  Created by David Russell on 7/3/21.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var tweet: Tweet

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(tweet.referencedTweets) { refrencedTweet in
                        TweetView(tweet: refrencedTweet)
                    }
                }
                Section {
                    // TODO: make non-tappable
                    TweetView(tweet: tweet)
                }
                Section {
                    ForEach(tweet.replies) { reply in
                        TweetView(tweet: reply)
                    }
                }
            }
            .listStyle(.plain)
        }
        .alert(isPresented: $tweet.errorIsActive) {
            NetworkErrorAlert.alert(for: tweet.activeError)
        }
        .task {
            if tweet.replies.isEmpty && tweet.referencedTweets.isEmpty {
                await tweet.getReferencedTweets()
                await tweet.getReplies()
            }
        }
        .navigationBarTitle("Conversation", displayMode: .inline)
    }

}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationView()
//    }
//}
