//
//  Content.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI

struct Content {
    var id: UUID = UUID() // 게시물 구별용
    var image: String? // 게시글 이미지
    var text: String? // 게시글 내용
    var likeCount: Int = 0  // 좋아요 수
}
