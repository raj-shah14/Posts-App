//
//  LoginModel.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import Foundation

struct LoginModel:Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
}
