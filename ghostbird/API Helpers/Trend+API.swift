//
//  Trend+API.swift
//  ghostbird
//
//  Created by David Russell on 7/8/21.
//

import Foundation

extension Trend {
    convenience init(api: TwitterAPIProtocol, apiTrend: TwitterAPI.Models.Trend, position: Int) {
        self.init(api: api,
                  name: apiTrend.name,
                  query: apiTrend.query.removingPercentEncoding! + " -is:retweet",
                  position: position,
                  tweetVolume: apiTrend.tweet_volume)
    }
}
