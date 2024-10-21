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
        switch authStore.authenticationState {
        case .unauthenticated:
            // 등록되지 않은 사용자
            if authStore.flow == .signUp {
                SignUpView()
            } else if authStore.flow == .login{
                SignInView()
            }
        case .authenticating:
            ProgressView()
        case .authenticated:
            // 등록된 사용자
            if authStore.flow == .profileSetting {
                // 닉네임이 비어있는 경우
                ProfileSettingView() // 프로필 설정 뷰
            } else if authStore.flow == .main {
                // 닉네임이 비어있지 않은 경우
                MainView() // 메인 뷰
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AuthenticationStore())
}
