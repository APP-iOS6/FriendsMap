//
//  FriendLIistView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/16/24.
//

import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var authStore: AuthenticationStore

//    init() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(Color(hex: "#6C96D5")) // 네비게이션 배경색 설정
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // 타이틀 텍스트 색상 설정
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // 큰 타이틀 텍스트 색상 설정
//        
//        appearance.shadowColor = .clear
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()

                VStack {
                    // 친구 목록 리스트
                    List(authStore.user.friends, id: \.self) { friendEmail in
                        HStack {
                            Text(friendEmail)
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.vertical, 9)
                            
                            Spacer()
                            // 거절 버튼
                            Button(action: {
                                Task {
                                    await authStore.removeFriend(to: friendEmail)
                                    authStore.user.friends.removeAll { $0 == friendEmail }  // 목록에서 제거
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                    .padding(.horizontal, 3)
                    
                    Spacer()
                }
                .onAppear {
                    Task {
                        await authStore.loadFriendData()
                    }
                }
            }
            .toolbar {
                // 종 모양과 플러스 버튼을 같은 선상에 배치
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendRequestsView()) {
                        Image(systemName: "bell")
                            .foregroundColor(Color.black)
                            .font(.system(size: 17))
                    }
                    NavigationLink(destination: AddFriendView()) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.black)
                            .font(.system(size: 17))
                    }
                }
            }
            .navigationTitle("친구목록")
            .navigationBarTitleDisplayMode(.inline) // 타이틀을 자동 모드로 설정
        }
    }
}
