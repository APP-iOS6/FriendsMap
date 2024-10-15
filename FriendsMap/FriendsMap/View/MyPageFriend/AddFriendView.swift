//
//  AddFriendView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

import SwiftUI
import Combine

struct AddFriendView: View {
    @StateObject var viewModel: FriendViewModel

    var body: some View {
        ZStack {
            Color(hex: "#404040")
                .ignoresSafeArea()

            VStack {
                TextField("친구의 닉네임을 검색해주세요", text: $viewModel.searchText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white) // 텍스트 필드 글자 색상을 흰색으로 설정
                    .padding(.horizontal)

                List {
                    ForEach(viewModel.filteredUsers, id: \.email) { user in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.purple)
                            VStack(alignment: .leading) {
                                Text(user.profile.nickname)
                                    .foregroundColor(.white)
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.addFriend(user.email) // 친구 추가 액션
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .listRowBackground(Color(hex: "#404040"))
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("친구 추가")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            profile: Profile(nickname: "샬라샬라샬라", image: ""),
            email: "aaa@gmail.com",
            contents: [],
            friends: [],
            requestList: [],
            receiveList: []
        )
        let viewModel = FriendViewModel(currentUser: sampleUser)
        AddFriendView(viewModel: viewModel)
    }
}
