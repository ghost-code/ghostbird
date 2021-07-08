//
//  ghostbirdApp.swift
//  ghostbird
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

@main
struct ghostbirdApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationView {
                let keys = TwitterAPI.Keys(key: TwitterKeys.key, secret: TwitterKeys.secret)
                let trends = Trends(api: TwitterAPI(keys: keys), woeid: 23424977)
                TrendsView(trends: trends)
            }
        }
    }
}

