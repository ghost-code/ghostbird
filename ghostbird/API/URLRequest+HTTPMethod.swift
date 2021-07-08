//
//  URLRequest+HTTPMethod.swift
//  ghostbird
//
//  Created by David Russell on 7/5/21.
//

import Foundation

extension URLRequest {

    enum HTTPMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    init(url: URL, method: HTTPMethod) {
        self = .init(url: url)
        httpMethod = method.rawValue
    }
}


