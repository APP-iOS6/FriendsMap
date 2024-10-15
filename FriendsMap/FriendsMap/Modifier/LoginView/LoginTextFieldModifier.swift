//
//  LoginTextFieldModifier.swift
//  FriendsMap
//
//  Created by 강승우 on 10/15/24.
//

import SwiftUI

struct LoginTextFieldModifier: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .padding()
            .textInputAutocapitalization(.never) // 처음 문자 자동으로 대문자로 바꿔주는 기능 막기
            .autocorrectionDisabled(true)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white, lineWidth: 1)
            }
    }
}
