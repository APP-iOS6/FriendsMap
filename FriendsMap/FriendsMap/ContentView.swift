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
        if authStore.authenticationState == .authenticated {
            MainView()
        } else if authStore.authenticationState == .unauthenticated{
            switch authStore.flow {
            case .login :
                SignInView()
            case .signUp :
                SignUpView()
            case .profileSetting:
                ProfileSettingView()
            }
        }
    }
}

struct testView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @EnvironmentObject var profileStore: ProfileStore
    
    var body: some View {
        //        VStack {
        //            if profileStore.isLoadingProfile {
        //                ProgressView()
        //            } else {
        //                if profileStore.isProfileCreated {
        //                    Button("logout") {
        //                        authStore.flow = .login
        //                        authStore.signOut()
        //                    }
        //                } else {
        //                    ProfileSettingView()
        //                }
        //            }
        //        }
        //        .onAppear {
        //            Task {
        //                await profileStore.loadProfile(email: authStore.email)
        //            }
        //        }
        
        switch authStore.authenticationState {
        case .unauthenticated:
            // 등록되지 않은 사용자
            if authStore.flow == .signUp {
                SignUpView()
            } else {
                SignInView()
            }
        case .authenticating:
            ProgressView()
        case .authenticated:
            // 등록된 사용자
            if let user = authStore.user, user.profile.nickname.isEmpty {
                // 닉네임이 비어있는 경우
                ProfileSettingView() // 프로필 설정 뷰
            } else {
                // 닉네임이 비어있지 않은 경우
                MainView() // 메인 뷰
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationStore())
        .environmentObject(ProfileStore())
}
