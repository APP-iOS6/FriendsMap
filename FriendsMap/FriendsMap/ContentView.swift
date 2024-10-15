//
//  ContentView.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @State var isLogin: Bool = false
    @State var isSignUp: Bool = false
    var body: some View {
        
        if isLogin {
            Text("로그인했습니다")
        } else {
            switch authStore.flow {
            case .login :
                SignInView()
            case .signUp :
                SignUpView()
            }
        }
    }
}

#Preview {
    ContentView()
}
