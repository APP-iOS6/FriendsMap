//
//  ImageManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ImageManagementView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject var authStore: AuthenticationStore
    
    var body: some View {
        ZStack {
            Color.loginViewBG.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 70) {
                    ForEach(userViewModel.user.contents, id: \.id) { content in
                        HStack (spacing: 50){
                            content.image
                                .resizable()
                                .frame(width: 100,height: 200)
                                .scaledToFit()
                            
                            Text("\(content.text)")
                                .font(.title3)
                            
                            Image(systemName: "minus")
                                .foregroundStyle(.red)
                                .frame(height: 10)
                                .background{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke()
                                        .frame(width: 35, height: 35)
                                }
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    Task {
                                        try await userViewModel.deleteContentImage(documentID: content.id, email: authStore.user!.email)
                                        try await userViewModel.fetchContents(from: authStore.user!.email)
                                    }
                                }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                Task {
                    try await userViewModel.fetchContents(from: authStore.user!.email)
                }
            }
        }
    }
}

#Preview {
    ImageManagementView()
}
