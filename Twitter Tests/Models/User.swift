//
//  Pofile.swift
//  Twitter Tests
//
//  Created by David Russell on 7/2/21.
//

import Foundation

struct User: Identifiable {
    let id: String
    let name: String
    let userName: String
    let imageURL: URL

    init(userDataObject: UserDataObject) {
        self.id = userDataObject.id
        self.name = userDataObject.name
        self.userName = userDataObject.username
        self.imageURL = userDataObject.profile_image_url
    }
}
