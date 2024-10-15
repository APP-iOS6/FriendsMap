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
    var body: some View {
        VStack (spacing: 35) {
            NavigationLink {
                ProfileManagementView()
            } label: {
                Text("프로필 관리")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                    .padding(.horizontal, 27)
            }
            
            NavigationLink {
                ImageManagementView()
            } label: {
                Text("업로드 이미지 관리")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    )
                    .padding(.horizontal, 27)
            }
        }
    }
}

#Preview {
    ProfileView()
}
