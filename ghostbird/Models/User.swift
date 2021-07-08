//
//  Pofile.swift
//  ghostbird
//
//  Created by David Russell on 7/2/21.
//

import Foundation

struct User: Identifiable {

    let id: String
    let name: String
    let userName: String
    let imageURL: URL?

    init(apiUser: TwitterAPI.Models.User.Data) {
        self.id = apiUser.id
        self.name = apiUser.name
        self.userName = apiUser.username
        self.imageURL = apiUser.profile_image_url
    }

}
