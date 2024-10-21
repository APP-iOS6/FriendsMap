//
//  LoginInViewCommon.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

@ViewBuilder
func createTextField(placeholder : String, varName : Binding<String>, isSecure: Bool) -> some View {
    ZStack(alignment: .leading) {
        if varName.wrappedValue.isEmpty {
            Text(placeholder)
                .font(.system(size: 16))
                .bold()
                .foregroundStyle(.white.opacity(0.7))
                .padding()
        }
        
        if isSecure {
            SecureField(placeholder, text: varName)
                .textFieldStyle(LoginTextFieldModifier())
        } else {
            TextField(placeholder, text: varName)
                .textFieldStyle(LoginTextFieldModifier())
        }
    }
}

func createTextFieldView(placeholder : String, varName : Binding<String>, isSecure: Bool, width: CGFloat, height: CGFloat, warningText: Binding<String>) -> some View {
    VStack(alignment : .leading) {
        createTextField(placeholder: placeholder, varName: varName, isSecure: isSecure)
            .frame(width: width)
        if !warningText.wrappedValue.isEmpty {
            Text(warningText.wrappedValue)
                .font(.system(size: 16))
                .foregroundStyle(.red)
                .padding(.leading)
        } else {
            Text("자리 채우기용")
                .font(.system(size: 16))
                .opacity(0)
        }
    }
    .frame(height: height)
}
