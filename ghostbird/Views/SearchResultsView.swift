//
//  SearchView.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct SearchView: View {

    @ObservedObject var search: Search

    var body: some View {
        List {
            ForEach(search.tweets) { tweet in
                TweetView(tweet: tweet)
            }
            loadMoreTweetsView
        }
        .listStyle(.plain)
        .task {
            if search.tweets.isEmpty {
                await search.getTweets()
            }
        }
        .refreshable {
            await search.getNewerTweets()
        }
        .navigationBarTitle(search.name, displayMode: .inline)
        .alert(isPresented: $search.errorIsActive) {
            NetworkErrorAlert.alert(for: search.activeError)
        }
    }

    @ViewBuilder
    var loadMoreTweetsView: some View {
        if !search.tweets.isEmpty {
            Button {
                Task(priority: .userInitiated) {
                    await search.getOlderTweets()
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
