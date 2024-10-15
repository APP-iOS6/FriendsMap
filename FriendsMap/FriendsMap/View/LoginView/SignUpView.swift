//
//  SignUpView.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordForCheck: String = ""
    
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
                
                Button {
                    
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
                
            }
            .frame(width:proxy.size.width, height: proxy.size.height)
            .background(.bgcolor)
        }
    }
}

#Preview {
    SignUpView()
}
