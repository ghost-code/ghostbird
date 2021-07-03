//
//  ErrorResponse.swift
//  Twitter Tests
//
//  Created by David Russell on 7/2/21.
//

import Foundation

struct ErrorResponse: Decodable {
    let clientId: String?
    let detail: String
    let reason: String?

    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case detail = "detail"
        case reason = "reason"
    }
}
