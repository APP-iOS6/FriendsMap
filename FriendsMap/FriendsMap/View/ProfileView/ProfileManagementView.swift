//
//  ProfileManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileManagementView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var authStore: AuthenticationStore
    
    @State private var newProfileImage: UIImage = UIImage()
    @State private var newNickname: String = ""
    
    @State private var isPresented: Bool = false
    @State private var changeCheck: String = ""
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    isPresented = true
                } label : {
                    ZStack {
                        if newProfileImage != UIImage() {
                            Image(uiImage: newProfileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                                .clipShape(.circle)
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.gray)
                                .offset(x : screenWidth * 0.13, y : screenHeight * 0.055)
                            
                        } else {
                            userViewModel.user.profile.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                                .clipShape(.circle)
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.gray)
                                .offset(x : screenWidth * 0.13, y : screenHeight * 0.055)
                        }
                        
                    }
                    .frame(width: screenWidth * 0.7, height: screenHeight * 0.18)
                    .padding(.bottom, 20)
                }
                
                HStack(spacing: 20) {
//                    Text("닉네임")
//                        .foregroundStyle(.white)
                    createTextField(placeholder: userViewModel.user.profile.nickname, varName: $newNickname, isSecure: false)
                        .frame(width: screenWidth * 0.5)
                }
            }
            
            .padding(.bottom, 60)
            
            Button {
                Task {
                    let imageData = newProfileImage.jpegData(compressionQuality: 0.8)
                    let result = await authStore.updateProfile(nickname: newNickname, image: imageData, email: authStore.user!.email)
                    if result {
                        changeCheck = "프로필 수정이 완료되었습니다"
                        print("업데이트 성공")
                    } else {
                        print("업데이트 안됨")
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screenWidth * 0.5, height: screenHeight * 0.06)
                        .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                    Text("수정하기")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 20)
            }
            
            Text(changeCheck)
                .font(.system(size: 18))
                .foregroundStyle(.white)
            
            .padding(.horizontal, 27)
        }
        .frame(width:screenWidth, height: screenHeight)
        .background(.loginViewBG)
        .sheet(isPresented: $isPresented) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$newProfileImage)
        }
        .navigationTitle("프로필 수정")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    ProfileManagementView()
}
