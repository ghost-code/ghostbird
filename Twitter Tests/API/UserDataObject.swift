//
//  UserDataObject.swift
//  Twitter Tests
//
//  Created by David Russell on 7/3/21.
//

import Foundation

struct UserDataObject: Identifiable, Decodable {
    let profile_image_url: URL
    let id: String
    let username: String
    let name: String
}
