//
//  ProfileStore.swift
//  FriendsMap
//
//  Created by 김수민 on 10/15/24.
//

import Foundation
import Observation
import FirebaseCore
import FirebaseFirestore


@MainActor
class ProfileStore: ObservableObject {
    
    func createProfile(email: String, nickname: String, image: String) async {
            do {
                let profile = Profile(nickname: nickname, image: image)
                let db = Firestore.firestore()
                try await db.collection("User").document(email).collection("Profile").document("profileDoc").setData([
                    "nickname": profile.nickname,
                    "image": profile.image,
                ])
            } catch {
                print(error)
            }
        }
}
