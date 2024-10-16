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
                
                let profileDoc = try await userDoc.reference.collection("Profile").document("profileDoc").getDocument()
                
                if profileDoc.exists {
                    if let nickname = profileDoc.get("nickname") as? String, !nickname.isEmpty {
                        // 닉네임이 비어있지 않으면 MainView로 이동
                        return true
                    } else {
                        // 닉네임이 비어있으면 ProfileSettingView로 이동
                        self.authenticationState = .unauthenticated
                        self.flow = .profileSetting
                        return false
                    }
                } else {
                    // ProfileDoc 문서가 없으면 ProfileSettingView로 이동
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
            let docRef = db.collection("User").document(email).collection("Profile").document("profileDoc")
            
            try await docRef.setData([
                "nickname": "",
                "image": ""
            ]
            )
            
            self.user = User(profile: Profile(nickname: "", image: ""), email: email, contents: [], friends: [], requestList: [], receiveList: [])
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
