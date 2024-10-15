//
//  ProfileViewModel.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

final class ProfileViewModel: ObservableObject {
    @Published private(set) var profile: Profile? = nil
    
}
