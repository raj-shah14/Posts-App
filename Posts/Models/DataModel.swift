//
//  DataModel.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import Foundation

struct User: Codable {
    let id: Int
    let first_name:String
    let last_name:String
    let email:String
    let created_at:String
}

struct Post: Codable {
    let title: String
    let content:String
    let id:Int
    let published:Bool
    let created_at: String
    let user: User
}

struct MainResponse : Codable {
    let Post: Post
    let Votes: Int
}


