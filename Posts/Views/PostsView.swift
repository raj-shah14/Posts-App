//
//  FastApiView.swift
//  Posts
//
//  Created by Raj Shah on 12/22/21.
//

import SwiftUI
import SwiftKeychainWrapper

struct PostsView: View {
    
    @State var access_token: String = KeychainWrapper.standard.string(forKey: "access_token") ?? ""
    @State var posts = [MainResponse]()
    @State var showCreatePostView = false
    @State var isHideLoader: Bool = true
    @State var updatePopUp: Bool = false
    @State var showLoginView: Bool = false
    @State var showSignoutAlert: Bool = false
    @State var isClicked: Bool = false
   
    @State var title: String = ""
    @State var content: String = ""
    @State var id: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack{
                List(posts, id: \.Post.id) { item in
                    VStack(alignment: .leading)
                    {
                        ItemRowView(post: item)
                    }
                    .swipeActions {
                        Button(action: {
                            self.isHideLoader = !self.isHideLoader
                            FastApiManager().deletePost(id: item.Post.id, access_token: access_token){ result in
                                self.isHideLoader = !self.isHideLoader
                                switch result {
                                    case .success(let msg):
                                        print(msg)
                                    case . failure(let error):
                                        print(error)
                                }
                            }
                        }) {
                        Image(systemName: "trash")
                        }
                        .tint(.red)
                        
                        Button(action: {
                                self.updatePopUp.toggle()
                                title = item.Post.title
                                content = item.Post.content
                                id = item.Post.id
                                }){
                                    Image(systemName: "pencil")
                                }
                            }
                            .tint(.blue)
                        }
                        //Pull down to refresh
                        .refreshable {
                        FastApiManager().getPosts { (posts) in
                            self.posts = posts.sorted(by: { $0.Post.created_at > $1.Post.created_at})
                            }
                        }
                        .fullScreenCover(isPresented: $updatePopUp){                   UpdateAlert(isHideLoader: isHideLoader, access_token: $access_token, updatePopUp: $updatePopUp, title: $title, content: $content, id: $id)
                        }
                }
                .onAppear() {
                    FastApiManager().getPosts { (posts) in
                        self.posts = posts.sorted(by: { $0.Post.created_at > $1.Post.created_at})
                        }
                }
                .navigationTitle("Posts")
                .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            self.showCreatePostView.toggle()
                            }) {
                                Image(systemName: "plus.message")
                                .resizable()
                                .padding(.trailing, 20)
                            }
                            .fullScreenCover(isPresented: $showCreatePostView){
                                CreatePostView(access_token: access_token)
                            }
                    
                    Button(action: {
                        self.showSignoutAlert.toggle()
                        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
                        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "username")
                        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "password")
                        }){
                            Image(systemName: "lock.open")
                                .resizable()
                        }
                        .alert(isPresented: $showSignoutAlert) {
                            Alert(title: Text("Are you sure you want to Signout?"), message: Text("Cancel to stay signed in"), primaryButton: .destructive(Text("SignOut")) {
                                self.showLoginView.toggle()
                            }, secondaryButton: .cancel())
                        }
                        .fullScreenCover(isPresented: $showLoginView){
                            LoginView()
                        }
                    }
                )
                LoaderView(tintColor: .black, scaleSize: 3.0)
                    .hidden(isHideLoader)
                .padding(.bottom, 20)
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()//title: .constant(""), content: .constant(""), id: .constant(0))
    }
}
