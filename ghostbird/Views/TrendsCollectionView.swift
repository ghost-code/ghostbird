//
//  TrendsView.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct TrendsCollectionView: View {

    @ObservedObject var trendsCollection: TrendsCollection

    @State var networkErrorAlertIsPresented: Bool = false
    @State var networkErrorAlertMessage: String = ""

    var body: some View {
        List(trendsCollection.trendSearchResults) { searchResults in
            NavigationLink(destination: SearchResultsView(searchResults: searchResults)) {
                VStack(alignment: .leading) {
                    Text(searchResults.name)
                }
            }
        }
        .task {
            if trendsCollection.trendSearchResults.isEmpty {
                await updateTrendsAction()
            }
        }
        .refreshable(action: updateTrendsAction)
        .alert(isPresented: $networkErrorAlertIsPresented, content: networkErrorAlert)
        .navigationBarTitle("Trends", displayMode: .inline)
    }

    func updateTrendsAction() async {
        do {
            try await trendsCollection.updateTrends()
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
