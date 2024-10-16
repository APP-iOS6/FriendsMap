//
//  ProfileCustomButton.swift
//  FriendsMap
//
//  Created by Soom on 10/16/24.
//

import SwiftUI

struct ProfileCustomButton: View {
    let buttonLabel: String
    let buttonForegroundColor: Color
    let buttonBackgroundColor: Color
    let buttonWidth: CGFloat
    let buttonAction: () -> ()
    var body: some View {
        VStack {
            Button {
                buttonAction()
            } label: {
                Text(buttonLabel)
                    .foregroundStyle(buttonForegroundColor)
                    .frame(maxWidth: buttonWidth)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(buttonBackgroundColor)
                    )
            }
        }
    }
}

#Preview {
    ProfileCustomButton(buttonLabel: "회원탈퇴", buttonForegroundColor: .gray, buttonBackgroundColor: .black, buttonWidth: .infinity) {
        
    }
}

