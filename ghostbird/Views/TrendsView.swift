//
//  TrendsView.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct TrendsView: View {

    @ObservedObject var trends: Trends

    @State var networkErrorAlertIsPresented: Bool = false
    @State var networkErrorAlertMessage: String = ""

    var body: some View {
        List(trends.trendsCollection) { trend in
            NavigationLink(destination: SearchResultsView(searchResults: trend.searchResults)) {
                VStack(alignment: .leading) {
                    Text(String(trend.position) + " " + trend.name)
                    if let tweetVolume = trend.tweetVolume {
                        Text(String(tweetVolume))
                    }
                }
            }
        }
        .task {
            if trends.trendsCollection.isEmpty {
                await updateTrendsAction()
            }
        }
        .refreshable(action: updateTrendsAction)
        .alert(isPresented: $networkErrorAlertIsPresented, content: networkErrorAlert)
        .navigationBarTitle("Trends", displayMode: .inline)
    }

    func updateTrendsAction() async {
        do {
            try await trends.getTrends()
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
