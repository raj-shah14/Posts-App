//
//  ContentView.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import SwiftUI

struct ContentView: View {
    @State private var signupIsShowing = false
    @State private var loginIsShowing = false
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            VStack {
            Image(systemName: "message.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                
            Text("Welcome to POSTSS!")
                    .font(.largeTitle)
            HStack {
                Button(action: {
                    self.loginIsShowing.toggle()
                }) {
                    Text("LOGIN")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding()
                         .frame(width: 140, height: 60)
                         .background(Color.green)
                         .cornerRadius(15.0)
                    }
                    .fullScreenCover(isPresented: $loginIsShowing) {
                        LoginView()
                    }
                
                Button(action: {
                    self.signupIsShowing.toggle()
                }) {
                    Text("SIGNUP")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding()
                         .frame(width: 140, height: 60)
                         .background(Color.green)
                         .cornerRadius(15.0)
                    }
                    .fullScreenCover(isPresented: $signupIsShowing) {
                        SignUpView()
                    }
                }
            }
            .padding(.bottom, 250)
        }
    }
}

let backgroundGradient = LinearGradient(
    gradient: Gradient(colors: [Color.blue, Color.cyan, Color.purple, Color.black]),
    startPoint: .top, endPoint: .bottom)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
