
//
//  AuthGoogle.swift
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
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            
            authenticationState = .authenticated
            
            self.user = User(profile: Profile(nickname: "", image: ""), email: firebaseUser.email!, contents: [], friends: [], requestList: [], receiveList: [])
            
            print("이메일!!! : \(String(describing: firebaseUser.email))")
            
            let db = Firestore.firestore()
            
            let userDocRef = db.collection("User").document(firebaseUser.email!)
            let userDoc = try await userDocRef.getDocument()
            
            // 최초로 로그인한 사용자
            if !userDoc.exists {
                // 필드 값 넣어주기
                try await userDocRef.setData([
                    "email": firebaseUser.email!,
                    "contents": [],
                    "friends": [],
                    "requestList": [],
                    "receiveList": []
                ])
                
                // 프로필 문서 넣어주기
                
                let profileDocRef = userDocRef.collection("Profile").document("profileDoc")
                try await profileDocRef.setData([
                    "nickname": "",
                    "image": ""
                ])
            
                // 콘텐츠 문서 넣어주기
                let contentDocRef = userDocRef.collection("Contents").document()
                try await contentDocRef.setData([
                    "contentDate" : Date(),
                    "image" : "",
                    "latitude" : 0,
                    "likeCount" : 0,
                    "longitude" : 0,
                    "text" : ""
                ])
            }
            
            let profileDoc = try await userDocRef.collection("Profile").document("profileDoc").getDocument()
            
            // 로그인한 기록이 있는 사용자
            if profileDoc.exists {
                if let nickname = profileDoc.get("nickname") as? String, !nickname.isEmpty {
                    // 닉네임이 비어있지 않으면 MainView로 이동
                    await self.loadProfile(email: firebaseUser.email!)
                    self.flow = .main
                    print(nickname)
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
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            
            return false
        }
    }
}
