//
//  ConversationView.swift
//  ghostbird
//
//  Created by David Russell on 7/3/21.
//

import SwiftUI

struct ConversationView: View {

    @ObservedObject var conversation: Conversation

    var body: some View {
        VStack(spacing: 0) {
            List {
                if conversation.referencedTweets.count > 0 {
                    Section(content: {
                        ForEach(conversation.referencedTweets) { refrencedTweet in
                            TweetView(tweet: refrencedTweet)
                        }
                    })
                }


                Section(content: {
                    ForEach(conversation.replies) { reply in
                        TweetView(tweet: reply)
                    }
                }, header: {
                    TweetView(tweet: conversation.tweet)
                }, footer: {
                    EmptyView().frame(height: 0)
                })
            }
            .listStyle(.plain)
        }
        .alert(isPresented: $conversation.observableError.errorIsActive) {
            NetworkErrorAlert.alert(for: conversation.observableError.activeError)
        }
        .onAppear {
            if conversation.replies.isEmpty && conversation.referencedTweets.isEmpty {
                Task {
                    await conversation.getReferencedTweets()
                    await conversation.getReplies()
                }
            }
        }
        .navigationBarTitle("Conversation")
    }

}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationView()
//    }
//}
