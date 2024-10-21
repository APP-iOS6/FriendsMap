//
//  Content.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI

struct Content {
    var id: String // 게시물 구별용
    var uiImage: UIImage?
    var text: String // 게시글 내용
    var likeCount: Int = 0  // 좋아요 수
    var contentDate: Date // 업로드 날짜
    var latitude: Double = 0.0 // 경도
    var longitude: Double = 0.0 // 위도
    
    var image: Image {
        if let uiImage {
            Image(uiImage: uiImage)
        } else {
            Image(systemName: "person.crop.circle")
        }
    }
}
