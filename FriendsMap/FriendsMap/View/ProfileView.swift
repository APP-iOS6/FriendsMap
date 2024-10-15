//
//  Profile.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.7).ignoresSafeArea()
                VStack {
                    Spacer()
                        .frame(height: 20)
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 150,height: 150)
                    Spacer()
                        .frame(height: 30)
                    
                    Text("Profile Name")
                        .font(.largeTitle)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    
                    ProfileButtonList()
                    
                    Spacer()
                    
                }
                Spacer()
            }
        }
    }
    func logoutButton()-> some View {
        Button {
            print("logout")
        } label: {
            Text("로그아웃")
                .foregroundStyle(.red)
                .padding(.vertical,16)
                .background(RoundedRectangle(cornerRadius: 16))
        }
    }
}
struct ProfileButtonList: View {
    let buttonLabels: [String] = ["프로필 관리", "업로드한 사진 관리", "친구 목록"]
    let buttonTextColors: [Color] = Array(repeating: Color.black, count: 3)
    let buttonBackgroundColors: [Color] = Array(repeating: Color.white, count: 3)
    var body: some View {
        VStack (spacing: 35) {
            ForEach(buttonLabels.indices) { index in
                NavigationLink {
                    Text( "\(index)" )
                    
                } label: {
                    Text(buttonLabels[index])
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(buttonTextColors[index])
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(buttonBackgroundColors[index])
                        )
                        .padding(.horizontal, 27)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
