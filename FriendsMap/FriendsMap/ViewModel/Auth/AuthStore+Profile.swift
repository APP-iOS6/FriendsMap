//
//  AuthStore+Profile.swift
//  FriendsMap
//
//  Created by 강승우 on 10/22/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore
import FirebaseStorage

extension AuthenticationStore {
    func fetchProfile( _ email: String) async {
        do {
            let profileDoc = try await db.collection("User").document(email).collection("Profile").document("profileDoc").getDocument().data()
            guard let profileDoc, let nickname = profileDoc["nickname"] as? String, let imagePath = profileDoc["image"] as? String else {
                print("profileDoc: 값이 존재하지 않음")
                return
            }
            let imageUrlString = await makeUrltoImage(email: email, imagePath: imagePath )
            
            DispatchQueue.main.async {
                self.loadImageFromUrl(imageUrlString: imageUrlString) { uiImage in
                    self.user.profile = Profile(nickname: nickname , uiimage: uiImage)
                }
            }
        } catch {
            print("Profile Fetch Error: \(error.localizedDescription)")
        }
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
                    self.user.profile = Profile(
                        nickname: nickname!,
                        uiimage: nil // ?? 왜 nil?
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
                self.user.profile.nickname = nickname
                return true
                
            } catch {
                print(error)
                return false
            }
        }
        // 이미지 등록 안한 경우
        else {
            do {
                let docRef =  db.collection("User").document(email).collection("Profile").document("profileDoc")
                try await docRef.setData([
                    "nickname": nickname
                ], merge: true)
                self.user.profile.nickname = nickname
                return true
            } catch {
                print(error)
                return false
            }
        }
    }
}
