//
//  FriendLIistView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/16/24.
//

import SwiftUI

struct FriendListView: View {
    @State private var profileImage: UIImage = UIImage()
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
                            Image(uiImage: profileImage)
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .padding(.trailing, 10)

                            Text(friend)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.vertical, 10)

                            Spacer()

                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(Color(hex: "#505050"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                        .listRowBackground(Color.clear)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 3)
                    
                    
                    Spacer()
                }
                .onAppear {
                    Task {
                        await viewModel.loadFriendData() // 친구 목록 로드
                    }
                }
            }
            .toolbar {
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
            .navigationTitle("친구 목록")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
