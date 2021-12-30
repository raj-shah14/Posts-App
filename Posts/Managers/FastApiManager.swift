//
//  FastApiManager.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage:String)
}


class FastApiManager: ObservableObject {
    @Published var values: [MainResponse] = []
    let baseURL = "https://fastapi-rajshah.herokuapp.com"
    
    func getPosts(completion: @escaping ([MainResponse]) -> ()) {
        guard let url = URL(string: baseURL + "/posts?limit=50") else { return }
        URLSession.shared.dataTask(with: url) { data, _,_ in
            let result = try! JSONDecoder().decode([MainResponse].self, from: data!)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
    
    func loginUser(username:String, password:String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        let params: [String: String] = ["username":username, "password":password]
        
        let url = baseURL + "/login"
        AF.request(url, method: .post, parameters: params).responseData { response in
            switch response.result {
            case .success:
                
                guard let data = response.data else { return }
                guard let responseData = try? JSONDecoder().decode(LoginResponse.self, from: data) else { completion(.failure(.custom(errorMessage: "Login Failed")))
                    return
                }
                let access_token = responseData.access_token
                let _: Bool = KeychainWrapper.standard.set(access_token, forKey: "access_token")
                let _: Bool = KeychainWrapper.standard.set(username, forKey: "username")
                let _: Bool = KeychainWrapper.standard.set(password, forKey: "password")
                
                completion(.success(access_token))
                        
            case .failure:
                completion(.failure(.custom(errorMessage: "Error decoding the data")))
                }
            }
        }
    
    func createUser(email: String, password: String, first_name:String, last_name:String, phone_number:String, completion: @escaping (Result<String, AuthenticationError>) -> Void){
        
        let json: [String: String] = ["email": email, "password": password, "first_name": first_name,
                                      "last_name": last_name, "phone_number": phone_number]
        
        var request = URLRequest(url: URL(string: baseURL + "/users")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
        guard let data = data, error == nil else { return }
        guard let signupResponse = try? JSONDecoder().decode(SignUpResponse.self, from: data) else {
            completion(.failure(.custom(errorMessage: "Failed to create user!")))
            return
        }
        guard let name = try? signupResponse.first_name else {
            return
        }
        completion(.success(first_name))
        }).resume()
    }
    
    func createPost(title: String, content:String, published: Bool, access_token:String, completion: @escaping (Result<String, AuthenticationError>) -> Void){
        
        let json: [String: Any] = ["title": title, "content": content, "published": published]
        
        var request = URLRequest(url: URL(string: baseURL + "/posts/createpost")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print(error)
            }
            
        guard let data = data, error == nil else { return }
            print(data)
            completion(.success("Post Created"))
            
        }).resume()
    }
    
    func deletePost(id: Int, access_token:String, completion: @escaping (Result<String, AuthenticationError>) -> Void){
        
        
        var request = URLRequest(url: URL(string: baseURL + "/posts/\(id)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
        guard let _ = data, error == nil else {
            completion(.failure(.custom(errorMessage:"Not able to Delete the Post!")))
            return }
        
            if let response = response as? HTTPURLResponse {
                    if (response.statusCode == 401 || response.statusCode == 403) {
                        completion(.failure(.custom(errorMessage: "Couldn't Delete the Post")))
                        return
                    }
                }
        completion(.success("Post Deleted"))
        }).resume()
    }
    
    func updatePost(title: String, content:String, id: Int, access_token:String, completion: @escaping (Result<String, AuthenticationError>) -> Void){
        
        let json: [String: Any] = ["title": title, "content": content]
        
        var request = URLRequest(url: URL(string: baseURL + "/posts/\(id)")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            
        guard let _ = data, error == nil else {
            completion(.failure(.custom(errorMessage:"Not able to Update the Post!")))
            return }
        
            if let response = response as? HTTPURLResponse {
                if (response.statusCode == 403) {
                    completion(.failure(.custom(errorMessage: "Not Authorized to Update the Post")))
                    return
                } else if (response.statusCode == 401){
                    completion(.failure(.custom(errorMessage: "Failed to verify Credentials")))
                    return
                }
            }
            
        completion(.success("Post Updated"))
            
        }.resume()
    }
}
    
                                   
