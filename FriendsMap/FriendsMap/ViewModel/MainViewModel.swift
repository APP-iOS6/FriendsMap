//
//  MainViewModel.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/15/24.
//

import Foundation
import Observation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

@MainActor
class MainViewModel: ObservableObject {
    @Published private(set) var userPost: [Content] = []

    func loadPosts(_ email: String) async {
        do {
            let db = Firestore.firestore()
            let userCollection = try await db.collection("User").document(email).collection("Contents").getDocuments()
            
            // var savedPosts: [Content] = [] // 임시 저장 공간
            
            for document in userCollection.documents {
                let id: String = document.documentID
                
                let docData = document.data()
                
                let text = docData["text"] as? String ?? ""
                let likeCount = docData["likeCount"] as? Int ?? 0
                
                let timestamp = docData["contentDate"] as? Timestamp
                let contentDate = timestamp?.dateValue() ?? Date()
                
                let latitude = docData["latitude"] as? Double ?? 0.0
                let longitude = docData["longitude"] as? Double ?? 0.0
                
                let image = docData["image"] as? String ?? ""
                let storageRef = Storage.storage().reference(withPath: "\(image)")
                
                let downloadURL = try await getDownloadURL(for: storageRef)
                print(downloadURL)
                
                self.userPost.append(Content(id: id, image: downloadURL, text: text, likeCount: likeCount, contentDate: contentDate, latitude: latitude, longitude: longitude))
            }
            
            print("유저 데이터 : \(userPost)")
            
        } catch {
            print("유저 데이터 가져오기 실패: \(error)")
        }
    }
    
    func getDownloadURL(for imageReference: StorageReference) async throws -> String {
        do {
            // 다운로드 URL 가져오기 (async/await)
            let url = try await imageReference.downloadURL()
            return url.absoluteString
        } catch let error {
            print("Error getting download URL: \(error)")
            throw error
        }
    }
}









