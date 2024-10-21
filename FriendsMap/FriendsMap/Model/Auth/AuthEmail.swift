//
//  AuthEmail.swift
//  FriendsMap
//
//  Created by 김수민 on 10/15/24.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

extension AuthenticationStore {
    func signInWithEmailPassword(email: String, password: String) async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            
            authenticationState = .authenticated
//            self.user = User(profile: Profile(nickname: "", image: "수민테스트"), email: email, contents: [], friends: [], requestList: [], receiveList: [])
            
            let db = Firestore.firestore()

            let profileDoc = try await db.collection("User").document(email).collection("Profile").document("profileDoc").getDocument()
            
            // 유저 문서가 존재하면
            if profileDoc.exists {
                if let nickname = profileDoc.get("nickname") as? String, !nickname.isEmpty {
                    // 닉네임이 비어있지 않으면 MainView로 이동
                    await self.loadProfile(email: email)
                    self.flow = .main
                    print("사용자 닉네임: \(nickname)")

                    return true
                } else {
                    // 닉네임이 비어있으면 ProfileSettingView로 이동
                    self.flow = .profileSetting
                    return false
                }
            } else {
                // ProfileDoc 문서가 없으면 ProfileSettingView로 이동
                self.flow = .profileSetting
                return false
            }
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword(email: String, password: String) async -> Bool {
        authenticationState = .authenticating
        do  {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            self.authenticationState = .authenticated
            // 회원가입 할 때 파베에 유저 등록(모든 필드는 처음에 빈 값으로 저장)
            let db = Firestore.firestore()
            let docRef = db.collection("User").document(email)
            
            try await docRef.setData([
                "email": email,
                "friends": [],
                "requestList": [],
                "receiveList": []
            ])
            
            // 프로필 문서 넣어주기
            let profileDocRef = docRef.collection("Profile").document("profileDoc")
            try await profileDocRef.setData([
                "nickname": "",
                "image": ""
            ])
            
            self.user = User(profile: Profile(nickname: "", uiimage: nil), email: email, contents: [], friends: [], requestList: [], receiveList: [])
            
            self.flow = .profileSetting // 프로필 설정 화면으로 이동
            return true
            
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
}
