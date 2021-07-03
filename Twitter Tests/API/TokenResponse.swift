//
//  TokenResponse.swift
//  Twitter Tests
//
//  Created by David Russell on 7/1/21.
//

import Foundation

struct TokenResponse: Decodable {
    let tokenType: String
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
    }
}
