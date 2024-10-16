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
}

// 인증 오류를 처리를 위한 타입
enum AuthenticationError: Error {
    case tokenError(message: String)
}

@MainActor
class AuthenticationStore: ObservableObject {
    @Published var name: String = "unkown"
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var firebaseUser: FirebaseAuth.User?
    @Published var displayName: String = ""
    
    @Published var profile: Profile = Profile(nickname: "", image: "")
    
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
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
//        if authStateHandler == nil {
//            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//                self.firebaseUser = user
//                self.authenticationState = user == nil ? .unauthenticated : .authenticated
//                self.displayName = user?.email ?? ""
//            }
//        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
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
