

//  FriendRequestView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//
// FriendRequestsView.swift

import SwiftUI

struct FriendRequestsView: View {
    @StateObject var viewModel: FriendViewModel
    @State private var currentFriendEmail: String?

    var body: some View {
        ZStack {
            Color(hex: "#404040")
                .ignoresSafeArea()

            VStack {
                Text("받은 친구 요청")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundColor(.white)
                    .padding()

                List {
                    ForEach(viewModel.receiveList, id: \.self) { friendEmail in
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                                .padding(.vertical)

                            Text(friendEmail)
                                .foregroundColor(.white)
                                .font(.system(size: 16))

                            Spacer()

                            // 수락 버튼
                            Button(action: {
                                Task {
                                    await viewModel.acceptFriendRequest(from: friendEmail)
                                    viewModel.receiveList.removeAll { $0 == friendEmail }
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
                                    await viewModel.rejectFriendRequest(from: friendEmail)
                                    viewModel.receiveList.removeAll { $0 == friendEmail }
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#505050"))
                        .cornerRadius(10)
                        .listRowBackground(Color.clear)
                    }
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .padding(.horizontal)

                Spacer()
            }
            .onAppear {
                Task {
                    await viewModel.loadFriendData() // 받은 요청 목록 로드
                }
            }
        }
    }
}
