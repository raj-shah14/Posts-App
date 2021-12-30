//
//  CreatePostView.swift
//  Posts
//
//  Created by Raj Shah on 12/24/21.
//

import SwiftUI

struct CreatePostView: View {
    @State var access_token: String
    @State var showPostsView = false
    @State var isHideLoader: Bool = true
    @State var showSuccessPopUp = false
    @State var showFailedPopUp = false
    @State var isPublished = true
    @State var title: String = ""
    @State var content: String = ""
    @State var id: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Title")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.black)
                    TextEditor(text: $title)
                        .multilineTextAlignment(.leading)
                        .padding(.top,3)
                        .font(.title2)
                        .frame(width: 360, height: 70, alignment: .leading)
                        .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.leading, .trailing], 2)
                                    .cornerRadius(16)
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 3).padding(.bottom, -10))
                                            .padding(.bottom, 15)
                    Text("Content")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.black)
                    TextEditor( text: $content)
                        .multilineTextAlignment(.leading)
                        .padding(.top,6)
                        .font(.title2)
                        .frame(width: 360, height: 250, alignment: .leading)
                        
                        .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.leading, .trailing], 2)
                                    .cornerRadius(16)
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 3).padding(.bottom, -10))
                    
                    HStack {
                        Image(systemName: isPublished ? "checkmark.square.fill" : "square")
                            .frame(width: 20, height: 50, alignment: .leading)
                            .foregroundColor(Color.black)
                                    .onTapGesture {
                                        self.isPublished.toggle()
                                    }
                        Text("Publish")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.black)
                    }
                    Button(action: {
                        self.isHideLoader = !self.isHideLoader
                        // TODO: Logic to send post
                        FastApiManager().createPost(title: title, content: content, published: isPublished, access_token: access_token) { result in
                            self.isHideLoader = !self.isHideLoader
                            switch result {
                                case .success:
                                    self.showSuccessPopUp.toggle()
                                case .failure:
                                    self.showFailedPopUp.toggle()
                            }
                        }
                    }){
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .padding()
                            .frame(width: 90, height: 70)
                            .foregroundColor(Color.cyan)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                            .padding(.bottom,10)
                    }
                    .alert("Failed to Post, Retry!", isPresented: $showFailedPopUp){
                        Button("Close", role: .cancel) {}
                    }
                    .alert("Post Submitted!!", isPresented: $showSuccessPopUp) {
                        Button(action: {
                            self.showPostsView.toggle()
                            title = ""
                            content = ""
                        })
                        {
                            Text("Get Posts!!")
                                .bold()
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                    .fullScreenCover(isPresented: $showPostsView){
                        PostsView()
                    }
                }
                .navigationTitle("Create Post")
                .navigationBarItems(leading:
                    Button(action:{
                    self.showPostsView.toggle()
                }){
                    HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                        .fullScreenCover(isPresented: $showPostsView){
                            PostsView()
                        }
                })
                
            }
            LoaderView(tintColor: .blue, scaleSize: 3.0)
                .hidden(isHideLoader)
                .padding(.bottom, 20)
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(access_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo1LCJleHAiOjE2NDA2NjIyMzh9.D0UGhm6UqHtqua6J0_wedIxbPv_tsWEJIC7BH2Dxxpk")
    }
}
