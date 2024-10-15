//
//  ProfileViewModel.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI
import PhotosUI
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

final class ProfileViewModel: ObservableObject {
    @Published private(set) var profile: Profile? = nil
    @Published private(set) var userContents: [Content] = []
    @Published private(set) var images: [UIImage] = []
    @Published private(set) var isLoading: Bool = false
    var user = User(profile: Profile(nickname: "", image: ""), email: "email", contents: [], friends: [], requestList: [], receiveList: [])
    var ref: DatabaseReference!
   
    func fetchContents(from email: String) async throws {
        ref = Database.database().reference()
        let db = Firestore.firestore()
        let storage = Storage.storage()
        do {
            let contents = try await db.collection("User").document(email).collection("Contents").getDocuments().documents
            
            for document in contents {
                let docData = document.data()
                let contentDate = docData["contentDate"] as? Date
                let imageData = docData["image"] as? String
                let storageRef = storage.reference(withPath: "\(imageData!)")
                let text = docData["text"] as? String
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        return
                    }
                    
                    if let url = url {
                        print("Download URL: \(url.absoluteString)")
                        self.userContents.append(Content(id: document.documentID, image: url.absoluteString, text: text, contentDate: .now))
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
