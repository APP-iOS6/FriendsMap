//
//  FriendLIistView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/16/24.
//


import SwiftUI

struct FriendListView: View {
    @StateObject var viewModel = FriendViewModel()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#404040")) // 네비게이션 배경색 설정
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // 타이틀 텍스트 색상 설정
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // 큰 타이틀 텍스트 색상 설정
        
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#404040")
                    .ignoresSafeArea()

                VStack {
                    // 친구 목록 리스트
                    List(viewModel.friends, id: \.self) { friend in
                        HStack {
                            Text(friend)
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.vertical, 9)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 29)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                        .listRowBackground(Color(hex: "#404040"))
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                    .padding(.horizontal, 3)
                    
                    Spacer()
                }
                .onAppear {
                    Task {
                        await viewModel.loadFriendData()
                    }
                }
            }
            .toolbar {
                // 종 모양과 플러스 버튼을 같은 선상에 배치
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendRequestsView(viewModel: viewModel)) {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                    }
                    NavigationLink(destination: AddFriendView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                    }
                }
            }
            .navigationTitle("친구목록")
            .navigationBarTitleDisplayMode(.inline) // 타이틀을 자동 모드로 설정
        }
    }
}
