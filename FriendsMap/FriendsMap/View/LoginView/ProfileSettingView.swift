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

    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 20) {
                HStack {
                    Image("logo_white")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: proxy.size.width * 0.5)
                .padding(.top, proxy.size.height * 0.05)
                
                Text("프로필 설정")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                    .padding(.bottom, proxy.size.height * 0.1)
                
                
                Button {
                    isPresented = true
                } label : {
                    ZStack {
                        if profileImage != UIImage() {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width * 0.4)
                                .clipShape(.circle)
                            
                        } else {
                            Image("defaultProfile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.4)
                                .clipShape(.circle)
                            Image(systemName: "plus")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.gray)
                                .offset(x : proxy.size.width * 0.13, y : proxy.size.height * 0.055)
                        }
                        
                        
                    }
                    .frame(width: proxy.size.width * 0.7, height: proxy.size.height * 0.18)
                }
                
                HStack {
                    createTextField(placeholder: "닉네임", varName: $nickname, isSecure: false)
                        .frame(width: proxy.size.width * 0.55)
                    
                    
                    Button {
                        // 닉네임 중복 확인 로직
                    } label : {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: proxy.size.width * 0.21, height: proxy.size.height * 0.065)
                                .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                            Text("중복확인")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.top, proxy.size.height * 0.02)
                
                Spacer()
                
                Button {
                    // 유저 정보 관리하는 vm에서 로그인 했다고 업데이트하기
                    Task {
                        await profileStore.updateProfile(nickname: nickname, image: "테스트수민", email: authStore.email)
                    }
                    //이미지 url 변환 필요함! 나중에 추가
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: proxy.size.width * 0.5, height: proxy.size.height * 0.05)
                            .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                        Text("시작하기")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, proxy.size.height * 0.06)
                }
                
            }
            .frame(width:proxy.size.width, height: proxy.size.height)
            .background(.loginViewBG)
            .sheet(isPresented: $isPresented) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileImage)
            }
        }
    }
}

#Preview {
    ProfileSettingView()
}
