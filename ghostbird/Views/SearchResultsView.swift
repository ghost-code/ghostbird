//
//  SearchResultsView.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct SearchResultsView: View {

    @ObservedObject var searchResults: SearchResults
    @State var networkErrorAlertIsPresented: Bool = false
    @State var networkErrorAlertMessage: String = ""

    var body: some View {
        List {
            ForEach(searchResults.tweets) { tweet in
                NavigationLink(destination: ConversationView(tweet: tweet)) {
                    TweetView(tweet: tweet)
                }
            }
            Button {
                async { await getOlderTweetsAction() }
            } label: {
                Text("Load older tweets")
            }
        }
        .listStyle(.plain)
        .alert(isPresented: $networkErrorAlertIsPresented, content: networkErrorAlert)
        .task {
            if searchResults.tweets.isEmpty {
                await getTweetsAction()
            }
        }
        .refreshable(action: getNewerTweetsAction)
        .navigationBarTitle(searchResults.name, displayMode: .inline)
    }

    func getTweetsAction() async {
        do {
            try await searchResults.getTweets()
        } catch {
            networkErrorAlertMessage = error.localizedDescription
            networkErrorAlertIsPresented = true
        }
    }

    func getNewerTweetsAction() async {
        do {
            try await searchResults.getNewerTweets()
        } catch {
            networkErrorAlertMessage = error.localizedDescription
            networkErrorAlertIsPresented = true
        }
    }

    func getOlderTweetsAction() async {
        do {
            try await searchResults.getOlderTweets()
        } catch {
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

//struct TrendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendView()
//    }
//}
