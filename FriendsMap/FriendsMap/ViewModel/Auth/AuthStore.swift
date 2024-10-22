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
import FirebaseStorage
import PhotosUI
import FirebaseDatabase

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
    @Published var user: User = User(profile: Profile(nickname: ""), email: "default", contents: [], friends: [], requestList: [], receiveList: [])
    @Published private(set) var isLoading: Bool = false
    let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    @Published var friendContents: [Content] = []
    @Published var imagelatitude: Double = 0.0
    @Published var imagelongitude: Double = 0.0
    @Published var imageDate: Date?
    var ref: DatabaseReference!
    
    // 파이어베이스 스토리지 (Image Upload)
    let storage = Storage.storage()
    
    
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
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            self.authenticationState = .unauthenticated
            self.flow = .login
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount( _ email: String) async -> Bool {
        let db = Firestore.firestore().collection("User").document(email)
        let imageStoragePath = Storage.storage().reference().child("\(email)/")
        
        do {
            try await db.collection("Profile").document("profileDoc").delete()
            
            let contentsDoc =  try await db.collection("Contents").getDocuments().documents
            
            for doc in contentsDoc {
                try await db.collection("Contents").document(doc.documentID).delete()
            }
            
            let imageList = try await imageStoragePath.listAll()
            
            for item in imageList.items {
                try await item.delete()
            }
            
            try await db.collection("Contents").document().delete()
            
            try await db.collection("Profile").document().delete()
            
            try await db.collection("User").document(email).delete()
            
            try await db.delete()
            
            try await firebaseUser?.delete()
            
            self.authenticationState = .unauthenticated
            
            self.flow = .login
            
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
