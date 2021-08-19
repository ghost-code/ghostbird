//
//  ObservableError.swift
//  ghostbird
//
//  Created by David Russell on 8/17/21.
//

import Foundation

class ObservableError: ObservableObject {

    @Published var errorIsActive: Bool = false {
        didSet {
            if !errorIsActive && activeError != nil {
                activeError = nil
            }
        }
    }

    var activeError: Error? {
        didSet {
            errorIsActive = activeError != nil
        }
    }

}
