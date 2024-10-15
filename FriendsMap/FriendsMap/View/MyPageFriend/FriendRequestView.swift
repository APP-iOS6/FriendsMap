//
//  FriendRequestView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

import SwiftUI
import Combine

struct FriendRequestsView: View {
    @StateObject var viewModel: FriendViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "#404040")
                .ignoresSafeArea()
            
            VStack {
                Text("\(viewModel.currentUser.profile.nickname) 님의 친구 요청")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                List {
                    ForEach(viewModel.currentUser.receiveList.indices, id: \.self) { index in
                        let requestEmail = viewModel.currentUser.receiveList[index]
                        
                        // 이메일을 통해서 allUsers 배열에서 해당 User를 찾는다
                        if let requestUser = viewModel.allUsers.first(where: { $0.email == requestEmail }) {
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.purple)
                                VStack(alignment: .leading) {
                                    Text(requestUser.profile.nickname) // 친구 요청 보낸 사람의 닉네임
                                        .foregroundStyle(Color.white)
                                    Text(requestUser.email) // 친구 요청 보낸 사람의 이메일
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    viewModel.acceptFriendRequest(at: index)
                                }) {
                                    Image(systemName: "checkmark.circle").foregroundColor(.green)
                                }
                                .buttonStyle(.borderless)
                                Button(action: {
                                    viewModel.rejectFriendRequest(at: index)
                                }) {
                                    Image(systemName: "xmark.circle").foregroundColor(.red)
                                }
                            }
                            .listRowBackground(Color(hex: "#404040"))
                        } else {
                            // 만약 allUsers에서 해당 친구 요청자를 찾지 못했을 경우
                            Text("Unknown User")
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("친구 요청")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FriendRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            profile: Profile(nickname: "샬라샬라샬라", image: ""),
            email: "aaa@gmail.com",
            contents: [],
            friends: [],
            requestList: [],
            receiveList: ["aaa@gmail.com", "aaa@gmail.com","friends"]
        )
        let viewModel = FriendViewModel(currentUser: sampleUser)
        FriendRequestsView(viewModel: viewModel)
    }
}
