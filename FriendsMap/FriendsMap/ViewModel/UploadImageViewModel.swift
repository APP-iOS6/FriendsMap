//
//  UploadImageViewModel.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import Foundation
import Observation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import UIKit

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

@MainActor
class UploadImageViewModel: ObservableObject {
    @Published var uiImage: UIImage? = nil
    @Published var imagelatitude: Double = 0.0
    @Published var imagelongitude: Double = 0.0
    @Published var imageDate: Date?
    
    // 게시글 생성
    func addImage(_ content: Content, _ image: Data?) async {
        let id = "\(UUID().uuidString)"
        let storageRef = Storage.storage().reference().child("\(id)")
        
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
            
            let userCollection = db.collection("User").document("j77777y@naver.com")
            
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
}
