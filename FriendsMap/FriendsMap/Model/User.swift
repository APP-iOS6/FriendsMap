//
//  User.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI

struct User {
    var profile: Profile
    var email: String
    var contents : [Content]
    var friends: [User]
    var requestList: [User]
    var receiveList: [User]
}








