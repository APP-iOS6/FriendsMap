//
//  FriendsMapApp.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FriendsMapApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
          let sampleUser = User(
              profile: Profile(nickname: "샬라샬라샬라", image: ""),
              email: "aaa@gmail.com",
              contents: [],
              friends: [],
              requestList: ["request1@gmail.com", "request2@gmail.com"],
              receiveList: ["request1@gmail.com", "request2@gmail.com"]
          )
          let viewModel = FriendViewModel(currentUser: sampleUser)
          FriendListView(viewModel: viewModel)
      }
    }
  }
}
