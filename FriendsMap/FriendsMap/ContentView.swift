//
//  ContentView.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @EnvironmentObject var profileStore: ProfileStore
    @State var isLogin: Bool = false
    @State var isSignUp: Bool = false
    var body: some View {
        
        switch authStore.authenticationState {
        case .authenticated :
            Button("로그아웃") {
                authStore.signOut()
            }
            .buttonStyle(.borderedProminent)
        case .unauthenticated :
            switch authStore.flow {
            case .login :
                SignInView()
            case .signUp :
                SignUpView()
            } 
        case .authenticating:
            VStack {
                ProgressView()
                Text("loading...")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationStore())
        .environmentObject(ProfileStore())
}
