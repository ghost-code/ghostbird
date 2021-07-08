//
//  NetworkErrorAlert.swift
//  ghostbird
//
//  Created by David Russell on 7/8/21.
//

import SwiftUI

class NetworkErrorAlert {
    static func alert(for error: Error?) -> Alert {
        Alert(title: Text("Network Error"),
              message: Text(error?.localizedDescription ?? ""),
              dismissButton: .cancel())
    }
}

