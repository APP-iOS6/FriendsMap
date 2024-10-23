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
    @State var emailWarningText: String = ""
    @State var passwordWarningText: String = ""
    @State var isGoogleLogin: Bool = false
    @State private var isKeyboardVisible: Bool = false
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack { // 로고 크기 조절용
                    Image("logoBlue")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: screenWidth * 0.5)
                .padding(.top, screenHeight * 0.1)
                
                Text("SIGN IN")
                    .foregroundStyle(Color(hex: "6C96D5"))
                    .font(.title)
                    .bold()
                    .padding(.bottom, screenHeight * 0.05)
                
                createTextFieldView(placeholder: "이메일", varName: $email, isSecure: false, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $emailWarningText)
                
                createTextFieldView(placeholder: "비밀번호", varName: $password, isSecure: true, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $passwordWarningText)
                
                VStack(spacing: 11) {
                    Button {
                        if checkValidInputs() {
                            Task {
                                let success = await authStore.signInWithEmailPassword(email: email, password: password)
                                if !success {
                                    passwordWarningText = "아이디 또는 비밀번호가 일치하지 않습니다"
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: screenWidth * 0.85, height: screenHeight * 0.06)
                                .foregroundStyle(Color(hex: "6C96D5"))
                            Text("로그인")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    HStack {
                        Text("아직 회원이 아니신가요?")
                            .foregroundStyle(Color(hex: "6C96D5").opacity(0.8))
                        
                        Button{
                            authStore.switchFlow(to: .signUp)
                        } label : {
                            Text("회원가입")
                                .foregroundStyle(Color(hex: "6C96D5").opacity(0.8))
                                .underline()
                        }
                    }
                }
                .padding(.bottom, screenHeight * 0.08)
                
                
                HStack(spacing : 5) {
                    Rectangle()
                        .frame(width: screenWidth * 0.35, height: 1)
                        .foregroundStyle(.gray)
                    
                    Text("OR")
                        .foregroundStyle(Color(hex: "6C96D5").opacity(0.7))
                    Rectangle()
                        .frame(width: screenWidth * 0.35, height: 1)
                        .foregroundStyle(.gray)
                }
                
                Button {
                    Task {
                        isGoogleLogin =  await authStore.signInWithGoogle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: screenWidth * 0.85, height: screenHeight * 0.06)
                            .foregroundStyle(.white)
                            .shadow(radius: 2, x: 1, y: 1)
                        HStack {
                            Image("googleLogo")
                                .resizable()
                                .frame(width: screenHeight * 0.035, height: screenHeight * 0.035)
                                .scaledToFit()
                                .padding()
                            
                            Text("Google 계정으로 로그인")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 16))
                                .padding(.horizontal,24)
                            Spacer()
                        }
                    }
                    .frame(width: screenWidth * 0.85, height: screenHeight * 0.06)
                    .padding(.bottom, screenHeight * 0.085)
                }
            }
            .frame(width: screenWidth, height: screenHeight)
        }
        .scrollDisabled(!isKeyboardVisible)
        .background(.white)
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            // 키보드 이벤트 감지
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible = true
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible = false
                }
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 옵저버 제거
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}

extension SignInView {
    private func resetWarningTexts() {
        self.emailWarningText = ""
        self.passwordWarningText = ""
    }
    
    private func checkValidInputs() -> Bool {
        resetWarningTexts()
        var isOccurError: Bool = false
        
        if email.isEmpty {
            emailWarningText = "이메일을 입력해주세요"
            isOccurError = true
        }
        
        if password.isEmpty {
            passwordWarningText = "비밀번호를 입력해주세요"
            isOccurError = true
        }
        
        if isOccurError {
            return false
        }
        return true
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationStore())
}
