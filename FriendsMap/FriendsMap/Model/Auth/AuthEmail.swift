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
            print("로그인 성공")
            
            authenticationState = .authenticated
            
            let db = Firestore.firestore()
            let userDoc = try await db.collection("User").document(email).getDocument()
            
            // 유저 문서가 존재하면
            if userDoc.exists {
                if let nickname = userDoc.get("profile.nickname") as? String, !nickname.isEmpty {
                    // 닉네임이 비어있지 않으면 MainView로 이동
                    self.authenticationState = .authenticated
                    return true
                } else {
                    // 닉네임이 비어있으면 ProfileSettingView로 이동
                    self.authenticationState = .unauthenticated
                    self.flow = .profileSetting
                    return false
                }
            } else {
                // 신규 사용자이면 회원가입뷰로 이동
                self.authenticationState = .unauthenticated
                self.flow = .signUp
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
            
            // 회원가입 할 때 파베에 유저 등록(모든 필드는 처음에 빈 값으로 저장)
            let db = Firestore.firestore()
            let userDocument = [
                "email": email,
                "profile": [
                    "nickname": "",
                    "image": ""
                ],
                "contents": [],
                "friends": [],
                "requestList": [],
                "receiveList": []
            ] as [String: Any]
            
            try await db.collection("User").document(email).setData(userDocument)
            
            self.user = User(profile: Profile(nickname: "", image: ""), email: email, contents: [], friends: [], requestList: [], receiveList: [])
            self.flow = .profileSetting
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
