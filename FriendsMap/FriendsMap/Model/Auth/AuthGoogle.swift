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
            
            let db = Firestore.firestore()
            let docRef = db.collection("User").document(email).collection("Profile").document("profileDoc")
            
            try await docRef.setData([
                "nickname": "",
                "image": ""
            ]
            )
            
            let userDoc = db.collection("User").document(email)
            
            try await userDoc.setData([
                "email": email,
                "contents": [],
                "friends" : [],
                "requestList" : [],
                "receiveList": []
            ]
            )
            
            self.user = User(profile: Profile(nickname: "", image: ""), email: email, contents: [], friends: [], requestList: [], receiveList: [])
            
            self.flow = .profileSetting // 프로필 설정 화면으로 이동
            return true
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}
