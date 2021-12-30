//
//  LoginView.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import SwiftUI

struct LoginView: View {
    
    @State var loginSuccessPopUp = false
    @State var loginFailurePopUp = false
    @State var isHideLoader: Bool = true
    @State private var homeView = false
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack {
                WelcomeText()
                UserImage()
                UsernameTextField(username: $username)
                SecurePasswordField(password: $password)
                
                HStack {
                    Button(action: {
                        self.isHideLoader = !self.isHideLoader
                        FastApiManager().loginUser(username: username, password: password) { result in
                            self.isHideLoader = !self.isHideLoader
                            switch result {
                            case .success(let access_token):
                                self.loginSuccessPopUp.toggle()
                                print(access_token)
                            case .failure(let error):
                                self.loginFailurePopUp.toggle()
                                print(error.localizedDescription)
                            }
                        }
                    }) {
                        Text("LOGIN")
                             .font(.headline)
                             .foregroundColor(.white)
                             .padding()
                             .frame(width: 130, height: 60)
                             .background(Color.green)
                             .cornerRadius(15.0)
                        }
                        .disabled(username.isEmpty || password.isEmpty)
                        .fullScreenCover(isPresented: $loginSuccessPopUp) {
                            PostsView()
                        }
                        .alert("Login Failed, Try Again", isPresented: $loginFailurePopUp) {
                                Button("OK", role: .cancel) {}
                        }
                    Button(action: {
                        self.homeView.toggle()
                    }) {
                        Text("Cancel")
                             .font(.headline)
                             .foregroundColor(.white)
                             .padding()
                             .frame(width: 130, height: 60)
                             .background(Color.red)
                             .cornerRadius(15.0)
                    }
                    .fullScreenCover(isPresented: $homeView) {
                        ContentView()
                    }
                }
                .padding(.bottom,175)
            }
            LoaderView(tintColor: .black, scaleSize: 2.0).padding().hidden(isHideLoader)
            .padding(.bottom, 20)
        }
    }
}

struct WelcomeText: View {
    var body: some View {
        return Text("Log In")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
            .foregroundColor(Color.black)
    }
}

struct UserImage: View{
    var body: some View {
        return Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .padding()
                    .foregroundColor(Color.black)
    }
}


struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        TextField("Username", text: $username)
            .padding(10)
            .background(Color(UIColor.lightGray))
            .cornerRadius(5.0)
            .padding(.top, 5)
            .padding(.horizontal, 30)
    }
}

struct SecurePasswordField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding(10)
            .background(Color(UIColor.lightGray))
            .cornerRadius(5.0)
            .padding(.top, 5)
            .padding(.horizontal, 30)
            .padding(.bottom,10)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
