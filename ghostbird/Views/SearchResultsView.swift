//
//  SearchResultsView.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct SearchResultsView: View {

    @ObservedObject var searchResults: SearchResults

    var body: some View {
        List {
            ForEach(searchResults.tweets) { tweet in
                NavigationLink(destination: ConversationView(tweet: tweet)) {
                    TweetView(tweet: tweet)
                }
            }
            if !searchResults.tweets.isEmpty {
                Button {
                    async { await searchResults.getOlderTweets() }
                } label: {
                    Text("Load older tweets")
                }
            }
        }
        .listStyle(.plain)
        .task {
            if searchResults.tweets.isEmpty {
                await searchResults.getTweets()
            }
        }
        .refreshable {
            await searchResults.getNewerTweets()
        }
        .navigationBarTitle(searchResults.name, displayMode: .inline)
        .alert(isPresented: $searchResults.errorIsActive) {
            NetworkErrorAlert.alert(for: searchResults.activeError)
        }
    }
    
}

//struct TrendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendView()
//    }
//}
