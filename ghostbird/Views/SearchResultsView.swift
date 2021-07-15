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
                TweetView(tweet: tweet)
            }
            loadMoreTweetsView
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

    @ViewBuilder
    var loadMoreTweetsView: some View {
        if !searchResults.tweets.isEmpty {
            Button {
                Task(priority: .userInitiated) {
                    await searchResults.getOlderTweets()
                }
            } label: {
                Text("Load older tweets")
            }
        } else {
            EmptyView()
        }
    }
    
}

//struct TrendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendView()
//    }
//}
