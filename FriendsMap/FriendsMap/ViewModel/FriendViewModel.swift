//
//  FriendViewModel.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//

import Foundation

class FriendViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var searchText = ""
    
    // 전체 사용자 목록을 포함하는 배열
    @Published var allUsers: [User] = [
        User(profile: Profile(nickname: "샬라샬라샬라", image: ""), email: "aaa@gmail.com", contents: [], friends: [], requestList: [], receiveList: []),
        User(profile: Profile(nickname: "친구1", image: ""), email: "friend1@gmail.com", contents: [], friends: [], requestList: [], receiveList: []),
        User(profile: Profile(nickname: "친구2", image: ""), email: "friend2@gmail.com", contents: [], friends: [], requestList: [], receiveList: [])
    ]

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return [] // 검색어가 없으면 빈 배열 반환
        }
        return allUsers.filter { $0.profile.nickname.contains(searchText) } // 검색어가 포함된 친구 필터링
    }

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func addFriend(_ email: String) {
        currentUser.friends.append(email)
    }

    func removeFriend(at index: Int) {
        currentUser.friends.remove(at: index)
    }
    
    func acceptFriendRequest(at index: Int) {
        guard index < currentUser.receiveList.count else { return } // 인덱스 검증 추가
        let newFriend = currentUser.receiveList[index]
        currentUser.friends.append(newFriend)
        currentUser.receiveList.remove(at: index) // 정확한 인덱스에서만 제거
    }
    func rejectFriendRequest(at index: Int) {
        currentUser.receiveList.remove(at: index)
    }
}
