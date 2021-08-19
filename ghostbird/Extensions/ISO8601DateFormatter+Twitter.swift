//
//  ISO8601DateFormatter+Twitter.swift
//  ghostbird
//
//  Created by David Russell on 7/6/21.
//

import Foundation

extension ISO8601DateFormatter {

    static var twitter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [ .withFullDate,
                                    .withFullTime,
                                    .withDashSeparatorInDate,
                                    .withFractionalSeconds ]
        return formatter
    }

}
