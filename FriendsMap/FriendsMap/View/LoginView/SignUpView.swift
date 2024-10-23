//
//  SignUpView.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @Environment(\.presentationMode) var presentationMode
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordForCheck: String = ""
    @State var emailWarningText: String = ""
    @State var passwordWarningText: String = ""
    @State var checkPasswordWarningText: String = ""
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
                
                Text("SIGN UP")
                    .foregroundStyle(Color(hex: "6C96D5"))
                    .font(.title)
                    .bold()
                    .padding(.bottom, screenHeight * 0.05)
                
                createTextFieldView(placeholder: "이메일(ex. friends.map.com)", varName: $email, isSecure: false, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $emailWarningText)
                
                createTextFieldView(placeholder: "비밀번호(6글자 이상의 영문, 숫자)", varName: $password, isSecure: true, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $passwordWarningText)
                
                createTextFieldView(placeholder: "비밀번호 확인", varName: $passwordForCheck, isSecure: true, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $checkPasswordWarningText)
                
                
                VStack(spacing:11) {
                    Button {
                        if checkValidInputs() {
                            Task {
                                let success = await authStore.signUpWithEmailPassword(email: email, password: password)
                                
                                if !success {
                                    checkPasswordWarningText = "회원가입에 실패하였습니다"
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: screenWidth * 0.85, height: screenHeight * 0.06)
                                .foregroundStyle(Color(hex: "6C96D5"))
                            Text("회원가입")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                    }
                    HStack {
                        Text("이미 계정이 있으신가요?")
                            .foregroundStyle(Color(hex: "6C96D5").opacity(0.8))
                        
                        Button {
                            authStore.switchFlow(to: .login)
                        } label : {
                            Text("로그인")
                                .foregroundStyle(Color(hex: "6C96D5").opacity(0.8))
                                .underline()
                        }
                    }
                }
                .padding(.top, screenHeight * 0.05)
                .padding(.bottom, screenHeight * 0.1)
            }
            .frame(width:screenWidth, height: screenHeight)
            
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

extension SignUpView {
    private func resetWarningTexts() {
        self.emailWarningText = ""
        self.passwordWarningText = ""
        self.checkPasswordWarningText = ""
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
        
        if password != passwordForCheck || passwordForCheck.isEmpty {
            checkPasswordWarningText = "비밀번호가 일치하지 않습니다"
            isOccurError = true
        }
        
        if isOccurError {
            return false
        }
        return true
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationStore())
}
