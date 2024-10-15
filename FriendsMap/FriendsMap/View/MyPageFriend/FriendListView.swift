//
//  FriendLIistView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

import SwiftUI
import Combine

struct FriendListView: View {
    @StateObject var viewModel: FriendViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#404040")
                    .ignoresSafeArea()
                
                VStack {
                    Text("\(viewModel.currentUser.profile.nickname) 님의 친구")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    List {
                        ForEach(viewModel.currentUser.friends.indices, id: \.self) { index in
                            let friendEmail = viewModel.currentUser.friends[index]
                            
                            // 이메일을 통해서 allUsers 배열에서 해당 User를 찾는다
                            if let friend = viewModel.allUsers.first(where: { $0.email == friendEmail }) {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.purple)
                                    VStack(alignment: .leading) {
                                        Text(friend.profile.nickname) // 친구의 닉네임 표시
                                            .foregroundStyle(Color.white)
                                        Text(friend.email) // 친구의 이메일 표시
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: {
                                        viewModel.removeFriend(at: index)
                                    }) {
                                        Image(systemName: "minus.circle").foregroundColor(.red)
                                    }
                                }
                                .listRowBackground(Color(hex: "#404040"))
                            } else {
                                // 만약 allUsers에서 해당 친구를 찾지 못했을 경우
                                Text("Unknown User")
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddFriendView(viewModel: viewModel)) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.clear)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .padding()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendRequestsView(viewModel: viewModel)) {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationBarTitle("") // 네비게이션 바 타이틀은 비워두기
        }
    }
}
struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            profile: Profile(nickname: "샬라샬라샬라", image: ""),
            email: "aaa@gmail.com",
            contents: [],
            friends: [
            ],
            requestList: [],
            receiveList: []
        )
        let viewModel = FriendViewModel(currentUser: sampleUser)
        FriendListView(viewModel: viewModel)
    }
}
