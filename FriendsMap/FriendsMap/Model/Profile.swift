//
//  Profile.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI

struct Profile {
    var nickname: String {
        didSet {
            if nickname.isEmpty {
                nickname = "Unknown"
            }
        }
    }
    var uiimage: UIImage?
    var image: Image {
        if let uiimage = uiimage {
            Image(uiImage: uiimage)
        } else {
            Image(systemName: "person.circle")
        }
    }
}
