//
//  PostsApp.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import SwiftUI
import SwiftKeychainWrapper

@main
struct PostsApp: App {
    var body: some Scene {
        WindowGroup {
            let retreived_username: String? = KeychainWrapper.standard.string(forKey: "username")
            let retreived_password: String? = KeychainWrapper.standard.string(forKey: "password")
            let retreived_accesstoken: String? = KeychainWrapper.standard.string(forKey: "access_token")
            
            if ( retreived_username != nil  || retreived_password != nil || retreived_accesstoken != nil ){
                PostsView()
            } else {
                ContentView()
            }
        }
    }
}
