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

