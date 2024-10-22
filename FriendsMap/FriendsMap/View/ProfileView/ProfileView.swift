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
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.loginViewBG.ignoresSafeArea()
                VStack {
                    Spacer(minLength: 20)
                    authStore.user.profile.image
                        .resizable()
                        .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 20)
                    Text(authStore.user.profile.nickname)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 1, y: 1) // 그림자 효과 추가
                        .padding(.bottom, screenHeight * 0.07)
                    
                    
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
            print(isDeleted)
        }
    }
}

struct ProfileButtonList: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @Binding var isDeleteAccountAlertPresented: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (spacing: 30) {
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
                        .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
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
                        .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
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
                        .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                )
                .padding(.horizontal, 27)
            }
            .padding(.bottom, 40)
            

            Button {
                authStore.signOut()
                dismiss()
            } label: {
                Text("로그아웃")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
//                    .background(
//                        RoundedRectangle(cornerRadius: 16)
//                            .fill(Color(hex: "E5E5E5"))
//                    )
            }
            ProfileCustomButton(buttonLabel: "회원탈퇴", buttonForegroundColor: .gray, buttonBackgroundColor: .clear, buttonWidth: .infinity) {
                isDeleteAccountAlertPresented.toggle()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationStore())
}
