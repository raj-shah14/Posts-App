//
//  ItemRowView.swift
//  Posts
//
//  Created by Raj Shah on 12/31/21.
//

import SwiftUI

struct ItemRowView: View {
    let post: MainResponse
    @State var isClicked: Bool = false
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .padding(10)
                    VStack (alignment: .leading) {
                        Text(post.Post.user.first_name + " " + post.Post.user.last_name)
                            .font(.title2)
                            .bold()
                            .padding(.bottom,1)
                            .foregroundColor(Color.black)
                        Text(post.Post.created_at)
                            .font(.caption2)
                            .padding(.bottom,2)
                            .foregroundColor(Color.black)
                    }
                }
                
                Text(post.Post.title)
                    .multilineTextAlignment(.leading)
                    .font(.headline)
                    .padding(.bottom,3)
                    .foregroundColor(Color.black)
                Text(post.Post.content)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .padding(.bottom,3)
                
                HStack {
                    Button(action:{
                        //TODO: Get votes
                        
                        self.isClicked.toggle()
                    })
                    {
                    Image(systemName: isClicked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(Color.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text(String(post.Votes))
                        .foregroundColor(Color.black)
                
                }
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(post: example)
    }
}

#if DEBUG
let userexample = User(id:5, first_name: "Raj", last_name: "Shah", email: "a@b.com", created_at: "12/31/2021")
let postexample = Post(title: "Example Post", content: "Maple French Toast", id: 5, published:true, created_at:"12/31/2020", user: userexample)
let example = MainResponse(Post: postexample, Votes: 5)
#endif
