//
//  SignInView.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var warningText: String = ""
    @State var isGoogleLogin: Bool = false
    
    @EnvironmentObject var authStore: AuthenticationStore
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 20) {
                HStack { // 로고 크기 조절용
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: proxy.size.width * 0.5)
                .padding(.top, proxy.size.height * 0.1)
                
                Text("SIGN IN")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                
                createTextField(placeholder: "E-mail (xxx@.com 형식으로 입력해주세요)", varName: $email, isSecure: false)
                    .keyboardType(.emailAddress)
                    .frame(width: proxy.size.width * 0.85)
                    .padding(.top, proxy.size.height * 0.06)
                
                createTextField(placeholder: "Password", varName: $password, isSecure: true)
                    .frame(width: proxy.size.width * 0.85)
                
                if !warningText.isEmpty {
                    Text(warningText)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
                
                Button {
                    warningText = ""
                    
                    if email.isEmpty {
                        warningText = "이메일을 입력해주세요"
                        return
                    }
                    
                    if password.isEmpty {
                        warningText = "비밀번호를 입력해주세요"
                        return
                    }
                    
                    Task {
                        let success = await authStore.signInWithEmailPassword(email: email, password: password)
                        if !success {
                            warningText = "아이디 또는 비밀번호가 일치하지 않습니다"
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: proxy.size.width * 0.5, height: proxy.size.height * 0.05)
                            .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                        Text("로그인")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    .padding(.top, proxy.size.height * 0.04)
                    .padding(.bottom, proxy.size.height * 0.06)
                }
                
                Spacer()
                
                Text("소셜 계정으로 로그인하기")
                    .foregroundStyle(.white.opacity(0.7))
                
                HStack(spacing : proxy.size.width * 0.1) {
                    Button {
                        Task {
                            isGoogleLogin =  await authStore.signInWithGoogle()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                            Image("googleLogo")
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    }
                    
                    Button {
                        // 애플 로그인 로직
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                            Image("appleLogo")
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    }
                }
                .frame(height: proxy.size.height * 0.1)
                
                HStack {
                    Text("아직 회원이 아니신가요?")
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Button{
                        authStore.switchFlow()
                    } label : {
                        Text("회원가입")
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

#Preview {
    SignInView()
        .environmentObject(AuthenticationStore()) 
}
