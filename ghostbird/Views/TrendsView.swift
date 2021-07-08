//
//  TrendsView.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

struct TrendsView: View {

    @ObservedObject var trends: Trends

    var body: some View {
        List(trends.trendsCollection) { trend in
            NavigationLink(destination: SearchResultsView(searchResults: trend.searchResults)) {
                TrendListItemView(trend: trend)
            }
        }
        .task {
            if trends.trendsCollection.isEmpty {
                await trends.getTrends()
            }
        }
        .refreshable {
            await trends.getTrends()
        }
        .navigationBarTitle("Trends", displayMode: .inline)
        .alert(isPresented: $trends.errorIsActive) {
            NetworkErrorAlert.alert(for: trends.activeError)
        }
    }

}

struct TrendListItemView: View {

    let trend: Trend

    var body: some View {
        VStack(alignment: .leading) {
            Text(String(trend.position) + " " + trend.name)
            if let tweetVolume = trend.tweetVolume {
                Text(String(tweetVolume))
            }
        }
    }

}
