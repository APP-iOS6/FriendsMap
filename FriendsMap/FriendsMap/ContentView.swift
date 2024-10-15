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
            }
        }
    }
}

struct testView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @EnvironmentObject var profileStore: ProfileStore
    
    var body: some View {
        VStack {
            if profileStore.isLoadingProfile {
                ProgressView()
            } else {
                if profileStore.isProfileCreated {
                    Button("logout") {
                        authStore.flow = .login
                        authStore.signOut()
                    }
                } else {
                    ProfileSettingView()
                }
            }
        }
        .onAppear {
            Task {
                await profileStore.loadProfile(email: authStore.email)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationStore())
        .environmentObject(ProfileStore())
}
