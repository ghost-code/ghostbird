//
//  TrendsActor.swift
//  ghostbird
//
//  Created by David Russell on 8/18/21.
//

import Foundation

actor TrendsActor {

    func getTrends(for woeid: Int) async throws -> [Trend] {
        try await TwitterClient.shared.getTrends(for: woeid)
    }

}
