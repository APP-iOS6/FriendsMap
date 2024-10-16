//
//  ProfileSettingView.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct ProfileSettingView: View {
    @State var nickname: String = ""
    @State private var profileImage: UIImage = UIImage()
    @State private var isPresented: Bool = false
    
    @EnvironmentObject var authStore: AuthenticationStore
    @EnvironmentObject var profileStore: ProfileStore
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image("logo_white")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: screenWidth * 0.5)
            .padding(.top, screenHeight * 0.05)
            
            Text("프로필 설정")
                .foregroundStyle(.white)
                .font(.title)
                .bold()
                .padding(.bottom, screenHeight * 0.1)
            
            
            Button {
                isPresented = true
            } label : {
                ZStack {
                    if profileImage != UIImage() {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenWidth * 0.4)
                            .clipShape(.circle)
                        
                    } else {
                        Image("defaultProfile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.4)
                            .clipShape(.circle)
                        Image(systemName: "plus")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.gray)
                            .offset(x : screenWidth * 0.13, y : screenHeight * 0.055)
                    }
                    
                    
                }
                .frame(width: screenWidth * 0.7, height: screenHeight * 0.18)
            }
            
            HStack {
                createTextField(placeholder: "닉네임", varName: $nickname, isSecure: false)
                    .frame(width: screenWidth * 0.55)
                
                
                Button {
                    // 닉네임 중복 확인 로직
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: screenWidth * 0.21, height: screenHeight * 0.065)
                            .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                        Text("중복확인")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                    }
                    .padding(.vertical)
                }
            }
            .padding(.top, screenHeight * 0.02)
            
            Spacer()
            
            Button {
                // 유저 정보 관리하는 vm에서 로그인 했다고 업데이트하기
                Task {
                    let result = await profileStore.updateProfile(nickname: nickname, image: "테스트수민", email: authStore.user!.email)
                    if result {
                        authStore.flow = .main
                    }
                }
                //이미지 url 변환 필요함! 나중에 추가
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screenWidth * 0.5, height: screenHeight * 0.05)
                        .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                    Text("시작하기")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, screenHeight * 0.06)
            }
            
        }
        .frame(width:screenWidth, height: screenHeight)
        .background(.loginViewBG)
        .sheet(isPresented: $isPresented) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileImage)
        }
    }
}

#Preview {
    ProfileSettingView()
}
