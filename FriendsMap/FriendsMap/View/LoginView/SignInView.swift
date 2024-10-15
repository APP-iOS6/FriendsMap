//
//  SignInView.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @State var email: String = ""
    @State var password: String = ""
    @State var warningText: String = ""
    @State var isGoogleLogin: Bool = false
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack { // 로고 크기 조절용
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: screenWidth * 0.5)
                .padding(.top, screenHeight * 0.1)
                
                Text("SIGN IN")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                
                createTextField(placeholder: "이메일", varName: $email, isSecure: false)
                    .keyboardType(.emailAddress)
                    .frame(width: screenWidth * 0.85)
                    .padding(.top, screenHeight * 0.06)
                
                VStack(alignment : .leading) {
                    createTextField(placeholder: "비밀번호", varName: $password, isSecure: true)
                        .frame(width: screenWidth * 0.85)
                    
                    if !warningText.isEmpty {
                        Text(warningText)
                            .font(.system(size: 20))
                            .foregroundStyle(.red)
                            .padding(.leading)
                    } else {
                        Text("자리 채우기용")
                            .font(.system(size: 20))
                            .opacity(0)
                    }
                }
                .frame(height: screenHeight * 0.1)
                
                
                
                VStack(spacing: 7) {
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
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: screenWidth * 0.85, height: screenHeight * 0.06)
                                .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                            Text("로그인")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    
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
                .padding(.bottom, screenHeight * 0.1)
                
                
                Rectangle()
                    .frame(width: screenWidth * 0.8, height: 1)
                    .foregroundStyle(.gray)
                
                Text("소셜 계정으로 로그인하기")
                    .foregroundStyle(.white.opacity(0.7))
                
                HStack(spacing : screenWidth * 0.1) {
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
                .frame(height: screenHeight * 0.07)
            }
            .frame(width: screenWidth, height: screenHeight)
            .background(.loginViewBG)
            
            if authStore.authenticationState == .authenticating {
                VStack {
                    ProgressView()
                    Text("loading...")
                }
                .foregroundStyle(.gray.opacity(0.5))
                .frame(height: screenHeight * 0.5)
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationStore()) 
}
