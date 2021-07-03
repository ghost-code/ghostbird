//
//  TrendsView.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct TrendsCollectionView: View {

    @ObservedObject var trendsCollection: TrendsCollection

    @State var networkErrorAlertIsPresented: Bool = false
    @State var networkErrorMessage: String = ""

    var body: some View {
        List(trendsCollection.trends) { trend in
            NavigationLink(destination: TrendView(trend: trend)) {
                VStack(alignment: .leading) {
                    Text("\(trend.position) - \(trend.name)")
                    if let tweetVolume = trend.tweetVolume {
                        Text("\(tweetVolume)")
                            .font(.caption)
                    }
                }
            }
        }
        .task(updateTrendsAction)
        .refreshable(action: updateTrendsAction)
        .alert(isPresented: $networkErrorAlertIsPresented, content: networkErrorAlert)
        .navigationBarTitle("Trends", displayMode: .inline)
    }

    func updateTrendsAction() async {
        do {
            try await trendsCollection.updateTrends()
        } catch {
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
