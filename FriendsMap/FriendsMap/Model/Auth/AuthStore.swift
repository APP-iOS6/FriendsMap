//
//  AuthStore.swift
//  FriendsMap
//
//  Created by 김수민 on 10/15/24.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Observation
import FirebaseFirestore

// 인증 처리 상태
enum AuthenticationState {
    case unauthenticated    // 인증 안됨
    case authenticating     // 인증 진행중
    case authenticated      // 인증 완료
}

// 현재 보이는 인증 화면의 상태
enum AuthenticationFlow {
    case login  // 로그인 화면
    case signUp // 회원가입 화면
    case profileSetting // 프로필 설정 화면
    case main // 메인 화면
}

// 인증 오류를 처리를 위한 타입
enum AuthenticationError: Error {
    case tokenError(message: String)
}

@MainActor
class AuthenticationStore: ObservableObject {
    
    //--------------------------안 쓰지만 있는 놈들
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var firebaseUser: FirebaseAuth.User?
    @Published var isValid: Bool  = false
    @Published var displayName: String = ""
    //----------------------------
    
    @Published var flow: AuthenticationFlow = .login
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var user: User?
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    //이미지, 닉네임 불러오기 함수
    func loadProfile(email: String) async {
        do {
            let snapshots = try await db.collection("User").document(email).collection("Profile").getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                let nickname = docData["nickname"] as? String
                let image = docData["image"] as? String
                
                self.user?.profile = Profile(
                    nickname: nickname!,
                    image: image!
                )
            }
        } catch{
            print("\(error)")
        }
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
            self.user?.profile.nickname = nickname
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func registerAuthStateHandler() {
        //        if authStateHandler == nil { // 자동로그인 추가하면 안됨
        //            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        //                if let user = user {
        //                    self.user?.email = user.email ?? ""
        //                    self.authenticationState = user == nil ? .unauthenticated : .authenticated
        //                    self.displayName = user.email ?? ""
        //                    
        //                    if self.authenticationState == .authenticated {
        //                        Task {
        //                            await self.loadProfile(email: user.email!)
        //                        }
        //                    }
        //                    
        //                }
        //            }
        //        }
        signOut()
    }
    
    func switchFlow(to newFlow: AuthenticationFlow) {
        flow = newFlow
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        }
        catch { }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthenticationStore {
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await firebaseUser?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
