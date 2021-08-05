//
//  TwitterAPI+QueryItems.swift
//  TwitterAPI+QueryItems
//
//  Created by David Russell on 8/5/21.
//

import Foundation

extension TwitterAPI {

    struct QueryItems {

        static let userFields = URLQueryItem(name: "user.fields",
                                             value: "created_at,description,entities,id," +
                                             "location,name,pinned_tweet_id," +
                                             "profile_image_url,protected," +
                                             "public_metrics,url,username,verified")

        static let expansions = URLQueryItem(name: "expansions",
                                             value: "author_id,entities.mentions.username," +
                                                    "referenced_tweets.id," +
                                                    "referenced_tweets.id.author_id")

        static let tweetFields = URLQueryItem(name: "tweet.fields",
                                              value: "conversation_id,created_at,entities,lang," +
                                                     "public_metrics,referenced_tweets," +
                                                     "reply_settings")
    }

}
