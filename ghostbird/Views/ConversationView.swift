//
//  ConversationView.swift
//  ghostbird
//
//  Created by David Russell on 7/3/21.
//

import SwiftUI

struct ConversationView: View {
    @ObservedObject var tweet: Tweet

    @State var networkErrorAlertIsPresented: Bool = false
    @State var networkErrorAlertMessage: String = ""

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(tweet.referencedTweets) { rferencedTweet in
                        NavigationLink(destination: ConversationView(tweet: rferencedTweet)) {
                            TweetView(tweet: rferencedTweet)
                        }
                    }
                }
                Section {
                    TweetView(tweet: tweet)
                }
                Section {
                    ForEach(tweet.replies) { reply in
                        NavigationLink(destination: ConversationView(tweet: reply)) {
                            TweetView(tweet: reply)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .alert(isPresented: $networkErrorAlertIsPresented, content: networkErrorAlert)
        .task {
            if tweet.replies.isEmpty && tweet.referencedTweets.isEmpty {
                await getTweets()
            }
        }
        .navigationBarTitle("Conversation", displayMode: .inline)
    }

    func getTweets() async {
        do {
            try await tweet.getReferencedTweets()
            try await tweet.getReplies()
        } catch {
            print(error)
            networkErrorAlertMessage = error.localizedDescription
            networkErrorAlertIsPresented = true
        }
    }

    func networkErrorAlert() -> Alert {
        return Alert(title: Text("Network Error"),
                     message: Text(networkErrorAlertMessage),
                     dismissButton: .default(Text("OK")))
    }

}

//struct ConversationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationView()
//    }
//}
