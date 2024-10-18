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
        let storage = Storage.storage()
        do {
            let docData = try await db.collection("User").document(email).collection("Profile").document("profileDoc").getDocument()
            
            let nickname = docData["nickname"] as? String
            let image = docData["image"] as? String
            let storageRef = storage.reference(withPath: "\(email)/\(image!)")
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                if let url = url {
                    self.user?.profile = Profile(
                        nickname: nickname!,
                        image: url.absoluteString
                    )
                }
            }
        } catch{
            print("\(error)")
        }
    }
    
    
    //이미지, 닉네임 업데이트 함수
    func updateProfile(nickname: String, image: Data?, email: String) async -> Bool{
        
        //UserViewModel 코드 참고
        let id = "\(UUID().uuidString)"
        let storageRef = Storage.storage().reference().child("\(email)/\(id)")
        
        // 원하는 이미지 크기 (예: 300x300으로 크기 조정)
        let targetSize = CGSize(width: 720, height: 1080)
        
        if let image = image,
           let originalImage = UIImage(data: image),
           let resizedImage = originalImage.resize(to: targetSize),
           let resizedImageData = resizedImage.jpegData(compressionQuality: 0.8) {
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            do {
                storageRef.putData(resizedImageData, metadata: metadata)
                
                let docRef = db.collection("User").document(email).collection("Profile").document("profileDoc")
                try await docRef.setData([
                    "nickname": nickname,
                    "image": id
                ])
                self.user?.profile.nickname = nickname
                self.user?.profile.image = id
                return true
                
            } catch {
                print(error)
                return false
            }
        }
        // 이미지 등록 안한 경우
        else {
            do {
                let docRef = db.collection("User").document(email).collection("Profile").document()
                try await docRef.setData([
                    "nickname": nickname
                ], merge: true)
                self.user?.profile.nickname = nickname
                return true
            } catch {
                print(error)
                return false
            }
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
