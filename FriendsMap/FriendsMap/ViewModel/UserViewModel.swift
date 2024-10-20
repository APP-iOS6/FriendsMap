//
//  UserViewModel.swift
//  FriendsMap
//
//  Created by Soom on 10/17/24.
//

import SwiftUI
import PhotosUI
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class UserViewModel: ObservableObject {
    @Published private(set) var profile: Profile? = nil
    @Published private(set) var userContents: [Content] = []
    @Published private(set) var isLoading: Bool = false
    
    @Published var uiImage: UIImage? = nil
    @Published var imagelatitude: Double = 0.0
    @Published var imagelongitude: Double = 0.0
    @Published var imageDate: Date?
    var user = User(profile: Profile(nickname: "", image: ""), email: "email", contents: [], friends: [], requestList: [], receiveList: [])
    var ref: DatabaseReference!
    
    // 파이어 베이스 데이터베이스 (회원 정보 및 친구 정보 저장)
    let db = Firestore.firestore()
    // 파이어베이스 스토리지 (Image Upload)
    let storage = Storage.storage()
    
    func fetchContents(from email: String) async throws {
        do {
            let contents = try await db.collection("User").document(email).collection("Contents").getDocuments().documents
            for document in contents {
                let docData = document.data()
                let contentDate = docData["contentDate"] as? Date
                let imagePath = docData["image"] as? String
                let text = docData["text"] as? String
                let lati = docData["latitude"] as? Double
                let longti = docData["longitude"] as? Double
                
                if let imagePath { let imageUrlString = await makeUrltoImage(email: email, imagePath: imagePath)
                    if !userContents.contains(where: { $0.id == document.documentID }) {
                        DispatchQueue.main.async {
                            self.userContents.append( Content(id: document.documentID, image: imageUrlString, text: text, contentDate: .now, latitude: lati ?? 0.0, longitude: longti ?? 0.0))
                        }
                    }
                }
            }
        } catch {
            print("fetch date error: \(error.localizedDescription)")
        }
    }
    
    func fetchProfile( _ email: String) async {
        do {
            let profileDoc = try await db.collection("User").document(email).collection("Profile").document("profileDoc").getDocument().data()
            guard let profileDoc, let nickname = profileDoc["nickname"] as? String, let imagePath = profileDoc["image"] as? String else {
                print("profileDoc: 값이 존재하지 않음")
                profile = nil
                return
            }
            let imageUrlString = await makeUrltoImage(email: email, imagePath: imagePath )
            DispatchQueue.main.async {
                self.profile = Profile(nickname: nickname , image: imageUrlString)
                
            }
        } catch {
            print("Profile Fetch Error: \(error.localizedDescription)")
        }
    }
    
    func deleteContentImage(documentID: String, email: String) async throws {
        let storageRef = storage.reference()
        do {
            let imagePath = try await db.collection("User").document(email).collection("Contents").document(documentID).getDocument().get("image")
            try await db.collection("User").document(email).collection("Contents").document(documentID).delete()
            
            if let index = userContents.firstIndex(where: { $0.id == documentID } ) {
                DispatchQueue.main.async {
                    self.userContents.remove(at: index)
                }
            }
            if let imagePath = imagePath as? String {
                try await storageRef.child("\(email)/\(imagePath)").delete()
            }
        } catch {
            print("Delete Error: \(error.localizedDescription)")
        }
    }
    
    
    // 게시글 생성
    func addContent(_ content: Content, _ image: Data?, _ email: String) async {
        let id = "\(UUID().uuidString)"
        let storageRef = storage.reference().child("\(email)/\(id)")
        
        // 원하는 이미지 크기 (예: 300x300으로 크기 조정)
        let targetSize = CGSize(width: 720, height: 1080)
        
        if let imageData = image,
           let originalImage = UIImage(data: imageData),
           let resizedImage = originalImage.resize(to: targetSize),
           let resizedImageData = resizedImage.jpegData(compressionQuality: 0.8) { // 압축 퀄리티 조정
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.putData(resizedImageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("사진 error: \(error)")
                }
                if let metadata = metadata {
                    print("메타데이터: \(metadata)")
                }
            }
        } else {
            print("이미지 리사이징에 실패했습니다.")
        }
        
        do {
            let db = Firestore.firestore()
            
            let userCollection = db.collection("User").document(email)
            
            let userContents = userCollection.collection("Contents").document()
            
            let body: [String: Any] = [
                "contentDate" : content.contentDate,
                "image" : id,
                "likeCount" : content.likeCount,
                "text" : content.text ?? "",
                "latitude" : content.latitude,
                "longitude" : content.longitude,
            ]
            
            try await userContents.setData(body)
            
        } catch {
            print("게시글 생성에 실패했습니다. \(error)")
        }
    }
    
    // Metadata extraction
    func extractMetadata(from data: Data) {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] {
            if let gpsData = properties["{GPS}"] as? [String: Any] {
                if let latitude = gpsData["Latitude"] as? Double,
                   let latitudeRef = gpsData["LatitudeRef"] as? String,
                   let longitude = gpsData["Longitude"] as? Double,
                   let longitudeRef = gpsData["LongitudeRef"] as? String {
                    
                    imagelatitude = latitudeRef == "N" ? latitude : -latitude
                    imagelongitude = longitudeRef == "E" ? longitude : -longitude
                }
            }
            
            if let exifData = properties["{Exif}"] as? [String: Any],
               let dateString = exifData["DateTimeOriginal"] as? String {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                imageDate = formatter.date(from: dateString)
            }
        }
    }
    func makeUrltoImage(email: String, imagePath: String) async -> String {
        do {
            let storageRef = storage.reference(withPath: "\(email)/\(imagePath)")
            let url = try await storageRef.downloadURL()
            
            return url.absoluteString
        } catch let makeUrlError {
            print("make url error:\(makeUrlError)")
            return "make url error"
        }
    }
}
