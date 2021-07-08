//
//  TwitterAPIModel.swift
//  ghostbird
//
//  Created by David Russell on 7/3/21.
//

import Foundation

extension TwitterAPI.Models {

    struct Token: Decodable {
        let tokenType: String
        let accessToken: String

        enum CodingKeys: String, CodingKey {
            case tokenType = "token_type"
            case accessToken = "access_token"
        }
    }

}
