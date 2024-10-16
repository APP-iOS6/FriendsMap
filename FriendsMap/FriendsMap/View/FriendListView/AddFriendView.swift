//  AddFriendView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

import SwiftUI

struct AddFriendView: View {
    @StateObject var viewModel: FriendViewModel
    @State private var friendEmail = ""
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "#404040")
                .ignoresSafeArea()
            
            VStack {
                Text("친구추가")
                    .font(.system(size: 18))
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding()
                
                TextField("이메일을 입력하세요.", text: $friendEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                Button(action: {
                    Task {
                        errorMessage = nil
                        successMessage = nil
                        
                        let success = await viewModel.sendFriendRequest(to: friendEmail)
                        
                        if success {
                            successMessage = "성공적으로 친구 요청을 보냈습니다." // 성공 메시지
                        } else {
                            errorMessage = "해당 이메일의 사용자를 찾을 수 없습니다." // 에러 메시지
                        }
                    }
                }) {
                    Text("친구추가 요청")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(8)
                }
                
                // 성공 메시지 표시 (초록색)
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
                
                // 에러 메시지 표시 (빨간색)
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                Spacer()
                
            }
            .background(Color(hex: "#404040").ignoresSafeArea())
        }
        .onAppear {
            Task {
                await viewModel.loadFriendData() // 뷰가 나타날 때 친구 목록 로드
            }
        }
    }
}
