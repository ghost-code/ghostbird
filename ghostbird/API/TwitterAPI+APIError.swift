//
//  TwitterAPI+APIError.swift
//  ghostbird
//
//  Created by David Russell on 7/6/21.
//

import Foundation

extension TwitterAPI {

    enum APIError: Error, LocalizedError {
        case apiBadURL,
             apiNoData,
             responseStatusError(status: Int, message: String),
             noToken

        public var errorDescription: String? {
            switch self {
            case let .responseStatusError(_ , message):
                return message
            default:
                return ""
            }
        }
    }

}


