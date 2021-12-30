//
//  CreateUserModel.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import Foundation

struct SignUpModel {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phone_number: String
}

struct SignUpResponse: Codable {
    let id: Int
    let first_name :String
    let last_name :String
    let email :String
    let created_at :String
}
