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
            NavigationLink(destination: SearchView(search: trend.search)) {
                TrendListItemView(trend: trend)
            }
        }
        .onAppear {
            if trends.trendsCollection.isEmpty {
                Task { await trends.getTrends() }
            }
        }
        .refreshable {
            await trends.getTrends()
        }
        .navigationBarTitle("Trends")
        .alert(isPresented: $trends.observableError.errorIsActive) {
            NetworkErrorAlert.alert(for: trends.observableError.activeError)
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
