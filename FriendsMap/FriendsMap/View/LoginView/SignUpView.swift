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
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 20) {
            HStack { // 로고 크기 조절용
                Image("logo_white")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: screenWidth * 0.5)
            .padding(.top, screenHeight * 0.1)
            
            Text("SIGN UP")
                .foregroundStyle(.white)
                .font(.title)
                .bold()
                .padding(.bottom, screenHeight * 0.05)
            
            createTextFieldView(placeholder: "이메일(ex. friends.map.com)", varName: $email, isSecure: false, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $emailWarningText)
            
            createTextFieldView(placeholder: "비밀번호(6글자 이상의 영문, 숫자)", varName: $password, isSecure: true, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $passwordWarningText)
            
            createTextFieldView(placeholder: "비밀번호 확인", varName: $passwordForCheck, isSecure: true, width: screenWidth * 0.85, height: screenHeight * 0.08, warningText: $checkPasswordWarningText)
            
            
            VStack(spacing:7) {
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
                            .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                        Text("회원가입")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                }
                HStack {
                    Text("이미 계정이 있으신가요?")
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Button {
                        authStore.switchFlow()
                    } label : {
                        Text("로그인")
                            .foregroundStyle(.white.opacity(0.8))
                            .underline()
                    }
                }
            }
            .padding(.top, screenHeight * 0.05)
            .padding(.bottom, screenHeight * 0.1)
//            .padding(.bottom, screenHeight * 0.2)
        }
        .frame(width:screenWidth, height: screenHeight)
        .background(.loginViewBG)
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
