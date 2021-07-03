//
//  Twitter_TestsApp.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import SwiftUI

@main
struct Twitter_TestsApp: App {

    let api = TwitterAPI()
    let trendsColletion: TrendsCollection

    init() {
        self.trendsColletion = TrendsCollection(api: api)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TrendsCollectionView(trendsCollection: trendsColletion)
            }
        }
    }
}

