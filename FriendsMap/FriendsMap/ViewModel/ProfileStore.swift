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
    @Published var profile: Profile = Profile(nickname: "", image: "")
    @Published var isProfileCreated: Bool = false
    @Published var isLoadingProfile: Bool = false
    
    
    private let db = Firestore.firestore()
    
    func didCreateProfile() -> Bool { // 프로필 생성 유무 확인
        if profile.nickname.isEmpty || profile.image.isEmpty {
            return false
        }
        return true
    }
    
    
//    //이미지, 닉네임 저장하기 함수 (회원가입할 때)
//    func createProfile(email: String, nickname: String, image: String) async {
//        do {
//            let profile = Profile(nickname: nickname, image: image)
//            try await db.collection("User").document(email).collection("Profile").document("profileDoc").setData([
//                "nickname": profile.nickname,
//                "image": profile.image,
//            ])
//        } catch {
//            print(error)
//        }
//    }
    
    //이미지, 닉네임 불러오기 함수
    func loadProfile(email: String) async {
//        isLoadingProfile = true
        do {
            let snapshots = try await db.collection("User").document(email).collection("Profile").getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                let nickname = docData["nickname"] as? String
                let image = docData["image"] as? String
                
                self.profile = Profile(
                    nickname: nickname!,
                    image: image!
                )
//                if nickname != "" && image != "" {
//                    isProfileCreated = true
//                }
            }
        } catch{
            print("\(error)")
        }
//        isLoadingProfile = false
    }
    
    
    //이미지, 닉네임 수정 함수
    func updateProfile(nickname: String, image: String, email: String) async -> Bool{
        do {
            let docRef = db.collection("User").document(email).collection("Profile").document("profileDoc")
            try await docRef.setData([
                "nickname": nickname,
                "image": image
            ]
            )
            profile = Profile(nickname: nickname, image: image)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
}
