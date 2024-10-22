//  AddFriendView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

// AddFriendView.swift
import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @State private var friendEmail = ""
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#404040")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("친구 추가")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 30)

                VStack(alignment: .leading) {
                    Text("추가할 이메일 입력:")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    ZStack(alignment: .leading) {
                        // 플레이스홀더 텍스트
                        if friendEmail.isEmpty {
                            Text("friend@example.com")
                                .font(.system(size: 16))
                                .foregroundColor(.gray) // 회색 플레이스홀더 텍스트
                                .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
                        }

                        // 실제 입력 필드
                        TextField("Insert Email", text: $friendEmail)
                            .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
                            .background(Color.white)
                            .cornerRadius(12)
                            .foregroundColor(.black)  // 입력된 텍스트 색상 검정으로 설정
                            .focused($isTextFieldFocused)  // 포커스 상태 처리
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
                    if friendEmail.isEmpty {
                        errorMessage = "이메일을 입력하세요."
                        successMessage = nil
                        isTextFieldFocused = true
                    } else {
                        Task {
                            errorMessage = nil
                            successMessage = nil
                            
                            let resultMessage = await authStore.sendFriendRequest(to: friendEmail)
                            
                            if resultMessage.contains("성공") {
                                successMessage = resultMessage
                            } else {
                                errorMessage = resultMessage
                            }
                        }
                    }
                }) {
                    Text("친구 요청 보내기")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                
                if let successMessage = successMessage {
                    Text(successMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                VStack(alignment: .leading) {
                    Text("보낸 친구 요청목록")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .padding(.leading, 16)
                    
                    List(authStore.user.requestList, id: \.self) { friend in
                        Text(friend)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                            .cornerRadius(10)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}
