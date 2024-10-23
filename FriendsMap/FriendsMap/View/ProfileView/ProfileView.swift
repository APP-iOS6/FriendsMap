//
//  Profile.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @State private var isDeleteAccountAlertPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Spacer(minLength: 20)
                    authStore.user.profile.image
                        .resizable()
                        .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .padding(.bottom, 10)
                    Text(authStore.user.profile.nickname)
                        .font(.title2)
                        .foregroundStyle(Color(hex: "6C96D5"))
                    //                        .shadow(color: .black, radius: 2, x: 1, y: 1) // 그림자 효과 추가
                        .padding(.bottom, screenHeight * 0.015)
                        .fontWeight(.bold)
                    
                    
                    ProfileButtonList(isDeleteAccountAlertPresented: $isDeleteAccountAlertPresented)
                        .environmentObject(authStore)
                    
                }.alert(isPresented: $isDeleteAccountAlertPresented) {
                    Alert(
                        title: Text("회원탈퇴"),
                        message: Text("회원 탈퇴를 진행할까요?\n 이 작업은 되돌릴 수 없습니다."),
                        primaryButton: .default(
                            Text("취소"),
                            action: .some({
                                print("취소됨")
                            })
                        ),
                        secondaryButton: .destructive(
                            Text("회원탈퇴"),
                            action: deleteAccount
                        )
                    )
                }
                Spacer(minLength: 40)
            }
            .task {
                await authStore.fetchProfile(authStore.user.email)
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    func deleteAccount() {
        Task {
            let isDeleted = await authStore.deleteAccount(authStore.user.email)
            if isDeleted {
                print("계정이 삭제되었습니다.")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ProfileButtonList: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @Binding var isDeleteAccountAlertPresented: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (spacing: 40) {
            NavigationLink {
                ProfileManagementView()
            } label: {
                HStack {
                    Image(systemName: "person.fill")
                    Text("프로필 수정")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(hex: "6C96D5"))
                )
                .padding(.horizontal, 27)
            }
            
            NavigationLink {
                ContentManagementView()
            } label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("게시물 관리")
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(hex: "6C96D5"))
                )
                .padding(.horizontal, 27)
            }
            
            NavigationLink {
                friendsContents()
            } label: {
                HStack {
                    Image(systemName: "person.3.sequence.fill")
                    Text("친구의 게시물")
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(hex: "6C96D5"))
                )
                .padding(.horizontal, 27)
            }
            NavigationLink {
                FriendListView()
            } label: {
                HStack {
                    Image(systemName: "person.3.sequence.fill")
                    Text("친구 관리")
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(hex: "6C96D5"))
                )
                .padding(.horizontal, 27)
            }
            .padding(.bottom, 40)
            
            
            Button {
                authStore.signOut()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("로그아웃")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
            }
            ProfileCustomButton(buttonLabel: "회원탈퇴", buttonForegroundColor: .gray, buttonBackgroundColor: .clear, buttonWidth: .infinity) {
                isDeleteAccountAlertPresented.toggle()
            }
        }
    }
    func friendsContents()-> some View {
        ScrollView {
            Spacer(minLength: 20)
            VStack(spacing: 60) {
                ForEach(authStore.friendContents, id: \.id) { content in
                    HStack (spacing: 30){
                        content.image
                            .resizable()
                            .frame(width: 130, height: 170)
                            .scaledToFit()
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(content.text)
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: 120, alignment: .leading)
                            
                            Text(content.contentDateText)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: 120, alignment: .leading)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationStore())
}
