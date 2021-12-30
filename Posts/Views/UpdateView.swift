//
//  UpdateView.swift
//  Posts
//
//  Created by Raj Shah on 12/27/21.
//

import SwiftUI

struct UpdateAlert: View {
    @State var isHideLoader: Bool = false
    @Binding var access_token: String
    let screenSize = UIScreen.main.bounds
    
    @State var showSuccessPopUp = false
    @State var showFailedPopUp = false

    @Binding var updatePopUp: Bool
    @Binding var title: String
    @Binding var content: String
    @Binding var id: Int
//    var onDone: (String) -> Void = { _ in }
//    var onCancel: () -> Void = { }
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("Update Post")
                    .font(.headline)
                    .foregroundColor(Color.black)
                
                TextField(title, text: $title)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 10)
                    .foregroundColor(Color.black)
                
                TextEditor( text: $content)
                    .multilineTextAlignment(.leading)
                    .font(.title2)
                    .frame(width: 240, height: 170, alignment: .leading)
                    .padding(.top,5)
                    .padding(.bottom,10)
                    .foregroundColor(Color.black)
                
                HStack(spacing: 40) {
                    Button("Update") {
                        self.isHideLoader = !self.isHideLoader
                        FastApiManager().updatePost(title: title, content: content, id: id, access_token: access_token)
                                                    { result in
                           self.isHideLoader = !self.isHideLoader
                           switch result {
                               case .success(let msg):
                                    print(msg)
                                   self.showSuccessPopUp.toggle()
                               case .failure(let error):
                                    print(error)
                                   self.showFailedPopUp.toggle()
                                }
                            }
                        
                    }
                    .alert("Failed to Update, Maybe Unauthorized!", isPresented: $showFailedPopUp){
                        Button("Close", role: .cancel) {}
                    }
                    .alert("Post Submitted!!", isPresented: $showSuccessPopUp) {
                        Button(action: {
                            self.updatePopUp = false
                        })
                        {
                            Text("Post Updated!!")
                                .bold()
                        }
                    }
                    
                    Button("Cancel") {
                        self.updatePopUp = false
                    }
                }
            }
            .padding()
            .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.4)
            .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            .offset(y: updatePopUp ? 0 : screenSize.height)
            .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
        }
        LoaderView(tintColor: .black, scaleSize: 2.0).padding().hidden(isHideLoader)
        .padding(.bottom, 20)
    }
}

struct UpdateAlert_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAlert(access_token:.constant(""), updatePopUp: .constant(true), title: .constant(""), content: .constant(""), id:.constant(0))
    }
}
