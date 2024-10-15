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
    
    func loadPosts() async {
        do {
            let db = Firestore.firestore()
            let userCollection = try await db.collection("User").document("j77777y@naver.com").collection("Contents").getDocuments()
            
            var savedPosts: [Content] = [] // 임시 저장 공간
            
            for document in userCollection.documents {
                let id: String = document.documentID
                
                let docData = document.data()
                let image = docData["image"] as? String ?? ""
                let text = docData["text"] as? String ?? ""
                let likeCount = docData["likeCount"] as? Int ?? 0
                
                let timestamp = docData["contentDate"] as? Timestamp
                let contentDate = timestamp?.dateValue() ?? Date()
                
                let latitude = docData["latitude"] as? Double ?? 0.0
                let longitude = docData["longitude"] as? Double ?? 0.0
                
                let post = Content(id: id, image: image, text: text, likeCount: likeCount, contentDate: contentDate, latitude: latitude, longitude: longitude)
                savedPosts.append(post)
            }
            
            userPost = savedPosts
            print("유저 데이터 : \(userPost)")
            
        } catch {
            print("유저 데이터 가져오기 실패: \(error)")
        }
    }
}
