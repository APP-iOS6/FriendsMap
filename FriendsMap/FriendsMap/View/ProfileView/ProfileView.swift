//
//  Profile.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @EnvironmentObject var authStore: AuthenticationStore
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.loginViewBG.ignoresSafeArea()
                VStack {
                    Spacer()
                        .frame(height: 20)
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: screenWidth * 0.2, height: screenWidth * 0.2)
                    
                    Text("\(authStore.user!.profile.nickname)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 1, y: 1) // 그림자 효과 추가
                    
                    Spacer()
                        .frame(height: 100)
                    
                    ProfileButtonList()
                    
                    Spacer()
                    
                    ProfileCustomButton(buttonLabel: "로그아웃", buttonForegroundColor: .red, buttonBackgroundColor:   Color(hex: "E5E5E5"), buttonWidth: .infinity) {
                        
                    }
                    .padding(.horizontal, 27)
                    
                    ProfileCustomButton(buttonLabel: "회원탈퇴", buttonForegroundColor: .gray, buttonBackgroundColor: .clear, buttonWidth: .infinity) {
                        
                    }
                    .padding(.horizontal, 27)
                }
                Spacer()
            }
        }
    }
}

struct ProfileButtonList: View {
    var body: some View {
        VStack (spacing: 25) {
            NavigationLink {
                ProfileManagementView()
            } label: {
                HStack {
                    Image(systemName: "person.fill")
                    Text("프로필")
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color(hex: "E5E5E5"))
                )
                .padding(.horizontal, 27)
            }
            
            NavigationLink {
                ImageManagementView()
            } label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("게시물")
                }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color(hex: "E5E5E5"))
                    )
                    .padding(.horizontal, 27)
            }
            NavigationLink {
                FriendListView()
            } label: {
                HStack {
                    Image(systemName: "person.3.sequence.fill")
                    Text("친구")
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color(hex: "E5E5E5"))
                )
                .padding(.horizontal, 27)
            }
        }
    }
}

#Preview {
    ProfileView()
}
