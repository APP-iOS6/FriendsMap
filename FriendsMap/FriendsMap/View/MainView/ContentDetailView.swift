//
//  ImageDetailView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/21/24.
//

import SwiftUI

struct ContentDetailView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    
    let contentId: String
    
    var body: some View {
        VStack {
            Spacer()
            
            
            if let content = authStore.user.contents.first(where: { $0.id == contentId }) {
                
                
                VStack {
//                    Text("\(authStore.user.profile.nickname)님의 사진")
//                        .font(.headline)
//                        .padding(.bottom, 8)
                    
                    content.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 600, height: 600)
                        .cornerRadius(10)
                }
                
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(content.text)
                        .font(.body)
                        .padding()
                    
                    Text("Posted on \(content.contentDateText)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
            // 친구의 콘텐츠 찾기
            else if let friendContent = authStore.friendContents.first(where: { $0.id == contentId }) {
                
               
                VStack {
                    friendContent.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 600, height: 600)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(friendContent.text)
                        .font(.body)
                        .padding()
                    
                    Text("Posted on \(friendContent.contentDateText)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            } else {
                
                Text("Content not found.")
                    .font(.body)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Image Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
