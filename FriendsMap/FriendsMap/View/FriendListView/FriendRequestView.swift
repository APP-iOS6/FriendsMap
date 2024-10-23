
//  FriendRequestView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//
// FriendRequestsView.swift


import SwiftUI

struct FriendRequestsView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @State private var currentFriendEmail: String?

    var body: some View {
        NavigationStack{
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(authStore.user.receiveList, id: \.self) { friendEmail in
                            HStack {
                                Text(friendEmail)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                // 수락 버튼
                                Button(action: {
                                    Task {
                                        await authStore.acceptFriendRequest(from: friendEmail)
                                        authStore.user.receiveList.removeAll { $0 == friendEmail }  // 목록에서 제거
                                    }
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.borderless)
                                
                                // 거절 버튼
                                Button(action: {
                                    Task {
                                        await authStore.rejectFriendRequest(from: friendEmail)
                                        authStore.user.receiveList.removeAll { $0 == friendEmail }  // 목록에서 제거
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 24))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .onAppear {
                    Task {
                        await authStore.loadFriendData() // 받은 요청 목록 로드
                    }
                }
            }
            .navigationTitle("받은 친구 요청")
            .navigationBarTitleDisplayMode(.inline) // 타이틀을 자동 모드로 설정

        }
    }
}
