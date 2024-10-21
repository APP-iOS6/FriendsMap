//
//  ImageDetailView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/21/24.
//

import SwiftUI

struct ImageDetailView: View {
    let imageUrl: String
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var likeCount: Int = 0 // 좋아요 수를 상태로 저장
    @State private var isLiked: Bool = false // 좋아요 버튼 상태
    
    var body: some View {
        VStack {
            Spacer() // 상단에 Spacer 추가하여 콘텐츠를 중간으로 내림
            
            // 이미지 표시
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 500) // 최대 높이를 500으로 조정
            } placeholder: {
                ProgressView()
            }
            
            // 유저의 콘텐트 관련 정보 표시
            if let content = userViewModel.userContents.first(where: { $0.image == imageUrl }) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(content.text ?? "No description available")
                        .font(.body)
                        .padding()
                    
                    HStack {
                        // 좋아요 하트 버튼
                        Button(action: {
                            isLiked.toggle()
                            if isLiked {
                                likeCount += 1
                            } else {
                                likeCount -= 1
                            }
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .gray)
                                .font(.system(size: 30))
                        }
                        
                        Text("\(likeCount) Likes")
                            .font(.body)
                            .padding(.leading, 8)
                    }
                    .padding()
                    
                    Text("Posted on \(content.contentDate.formatted())")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .onAppear {
                    likeCount = content.likeCount // 최초 화면 로드 시 좋아요 수 설정
                }
            }
            
            Spacer() // 하단에 Spacer 추가하여 콘텐츠를 중간으로 내림
        }
        .navigationTitle("Image Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

