//
//  TwitterAPI+Keys.swift
//  ghostbird
//
//  Created by David Russell on 7/3/21.
//

import Foundation

extension TwitterAPI {

    struct Keys {
        let key: String
        let secret: String

        var bearer: String {
            let authString = key + ":" + secret
            return authString.data(using: .utf8)!.base64EncodedString()
        }
    }

}
