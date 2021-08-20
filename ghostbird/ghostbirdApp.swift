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
                let trends = Trends(woeid: 23424977)
                TrendsView(trends: trends)
            }
        }
    }
}

