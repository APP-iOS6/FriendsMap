//
//  SignUpView.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isSignUp: Bool
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordForCheck: String = ""
    @State var warningText: String = ""
    
    @EnvironmentObject var authStore: AuthenticationStore
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(spacing: 20) {
                    HStack { // 로고 크기 조절용
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: proxy.size.width * 0.5)
                    .padding(.top, proxy.size.height * 0.1)
                    
                    Text("SIGN UP")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .padding(.bottom, proxy.size.height * 0.06)
                    
                    createTextField(placeholder: "이메일", varName: $email, isSecure: false)
                        .keyboardType(.emailAddress)
                        .frame(width: proxy.size.width * 0.85)
                        .padding(.top, proxy.size.height * 0.02)
                    
                    createTextField(placeholder: "비밀번호", varName: $password, isSecure: true)
                        .frame(width: proxy.size.width * 0.85)
                        .padding(.top, proxy.size.height * 0.02)
                    
                    createTextField(placeholder: "비밀번호 확인", varName: $passwordForCheck, isSecure: true)
                        .frame(width: proxy.size.width * 0.85)
                        .padding(.top, proxy.size.height * 0.02)
                    
                    Spacer()
                    
                    NavigationLink {
                        ProfileSettingView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: proxy.size.width * 0.5, height: proxy.size.height * 0.05)
                                .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                            Text("회원가입")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, proxy.size.height * 0.06)
                    }
                    
                    HStack {
                        Text("이미 계정이 있으신가요?")
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Button {
                            isSignUp.toggle()
                        } label : {
                            Text("로그인")
                                .foregroundStyle(.white.opacity(0.8))
                                .underline()
                        }
                    }
                }
                .frame(width:proxy.size.width, height: proxy.size.height)
                .background(.loginViewBG)
            }
        }
    }
}

#Preview {
    @State var isSignUp: Bool = true
    SignUpView(isSignUp: $isSignUp)
}
