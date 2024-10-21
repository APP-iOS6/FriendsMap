//  AddFriendView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

// AddFriendView.swift
import SwiftUI

struct AddFriendView: View {
    @StateObject var viewModel: FriendViewModel
    @State private var friendEmail = ""
    @State private var errorMessage: String? = nil
    @State private var successMessage: String? = nil
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#404040") // 어두운 배경
                .ignoresSafeArea()

            VStack(spacing: 20) { // 요소 간의 간격 조정
                Text("친구 추가")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 30) // 상단 여백
                
                // 이메일 입력 필드
                VStack(alignment: .leading) {
                    Text("추가할 이메일 입력:")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    TextField("friend@example.com", text: $friendEmail)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .foregroundStyle(Color.black)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .focused($isTextFieldFocused) // 텍스트 필드 포커싱 상태
                }

                // 친구 추가 버튼
                Button(action: {
                    // 이메일이 비어있을 경우 경고 처리
                    if friendEmail.isEmpty {
                        errorMessage = "이메일을 입력하세요."
                        successMessage = nil
                        isTextFieldFocused = true
                    } else {
                        Task {
                            errorMessage = nil
                            successMessage = nil

                            let resultMessage = await viewModel.sendFriendRequest(to: friendEmail)

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
                        .background(Color.gray) // 이전 버전의 버튼 색상
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                }

                // 성공/에러 메시지 표시
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

                // 보낸 친구 요청 목록
                VStack(alignment: .leading) {
                    Text("보낸 친구 요청목록")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .padding(.leading, 16)
                    
                    List(viewModel.requestList, id: \.self) { friend in
                        Text(friend)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(.vertical, 8) // 리스트의 위아래 간격을 줄임
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
            isTextFieldFocused = false // 텍스트 필드 포커스 해제 (화면 터치 시 키보드 내려감)
        }
    }
}
