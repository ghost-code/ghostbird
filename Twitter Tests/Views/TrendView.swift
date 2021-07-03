//
//  TrendView.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct TrendView: View {

    @ObservedObject var trend: Trend

    @State var networkErrorAlertIsPresented: Bool = false
    @State var networkErrorMessage: String = ""

    var body: some View {
    List(trend.tweets) {
        TweetView(tweet: $0)
    }
        .alert(isPresented: $networkErrorAlertIsPresented, content: networkErrorAlert)
        .task(getSearchResultsAction)
        .refreshable(action: getSearchResultsAction)
        .navigationBarTitle(trend.name, displayMode: .inline)
    }

    func getSearchResultsAction() async {
        do {
            try await trend.getSearchResults()
        } catch {
            print(error)
            networkErrorMessage = error.localizedDescription
            networkErrorAlertIsPresented = true
        }
    }

    func networkErrorAlert() -> Alert {
        return Alert(title: Text("Network Error"),
                     message: Text(networkErrorMessage),
                     dismissButton: .default(Text("OK")))
    }
}

//struct TrendView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendView()
//    }
//}
