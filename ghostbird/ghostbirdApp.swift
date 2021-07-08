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
                let trendsCollection = TrendsCollection(api: TwitterAPI(keys: keys))
                TrendsCollectionView(trendsCollection: trendsCollection)
            }
        }
    }
}

