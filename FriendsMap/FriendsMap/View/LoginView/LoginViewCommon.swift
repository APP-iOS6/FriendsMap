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
