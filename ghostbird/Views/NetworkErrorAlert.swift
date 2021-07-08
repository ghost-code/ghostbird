//
//  NetworkErrorAlert.swift
//  ghostbird
//
//  Created by David Russell on 7/6/21.
//

import SwiftUI

struct NetworkErrorAlert {
    
    @State var message: String = ""

    func alert() -> Alert {
        return Alert(title: Text("Network Error"),
                     message: Text(message),
                     dismissButton: .default(Text("OK")))
    }

}
