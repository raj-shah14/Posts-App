//
//  SignUpView.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import SwiftUI

struct SignUpView: View {
    @State private var showSuccessPopUp = false
    @State private var showFailedPopUp = false
    @State var isHideLoader: Bool = true
    @State private var homeView = false
    @State private var showLoginView = false
    
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmpassword: String = ""
    @State var phone_number: String = ""
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                TextField("First Name", text: $first_name)
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.top, 5)
                    .padding(.horizontal, 30)
                TextField("Last Name", text: $last_name)
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.top, 5)
                    .padding(.horizontal, 30)
                TextField("Phone Number", text: $phone_number)
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.top,5)
                    .padding(.horizontal, 30)
                TextField("Email", text: $email)
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.top,5)
                    .padding(.horizontal, 30)
                SecureField("Password", text: $password)
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.top,5)
                    .padding(.horizontal, 30)
                SecureField("ConfirmPassword", text: $confirmpassword)
                    .padding(10)
                    .background(Color(UIColor.lightGray))
                    .cornerRadius(5.0)
                    .padding(.top,5)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                
                HStack {
                    
                    //Signup Button
                    Button(action: {
                        self.isHideLoader = !self.isHideLoader
                        FastApiManager().createUser(email: email, password: password, first_name: first_name, last_name: last_name, phone_number: phone_number) { result in
                            self.isHideLoader = !self.isHideLoader
                            switch result {
                                case .success:
                                    self.showSuccessPopUp.toggle()
                                case .failure:
                                    self.showFailedPopUp.toggle()
                            }
                        }
                    }) {
                        Text("Sign Up")
                             .font(.headline)
                             .foregroundColor(.white)
                             .padding()
                             .frame(width: 130, height: 60)
                             .background(Color.green)
                             .cornerRadius(15.0)
                        }
                        .alert("User Created", isPresented: $showSuccessPopUp) {
                            HStack {
                                Button("OK", role: .cancel) {
                                    first_name = ""
                                    last_name = ""
                                    email = ""
                                    password = ""
                                    confirmpassword = ""
                                    phone_number = ""
                                }
                                Button(action: {
                                    self.showLoginView.toggle()
                                })
                                {
                                    Text("Login")
                                        .bold()
                                }
                            }
                        }
                        .alert("Failed to create, Try again!", isPresented: $showFailedPopUp) {
                                Button("Close", role: .cancel) {}
                        }
                        .disabled(email.isEmpty || password.isEmpty || first_name.isEmpty || last_name.isEmpty)
                        .disabled(password != confirmpassword)
                        .fullScreenCover(isPresented: $showLoginView) {
                            LoginView()
                        }
                    
                    
                    //Cancel Button
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
            LoaderView(tintColor: .black, scaleSize: 3.0)
                .hidden(isHideLoader)
            .padding(.bottom, 20)
        }
    }
}



struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
