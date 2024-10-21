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
    
    @State private var showAlert = false
    @State private var selectedContent: Content?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.loginViewBG.ignoresSafeArea()
                ScrollView {
                    Spacer(minLength: 20)
                    
                    VStack(spacing: 60) {
                        ForEach(userViewModel.user.contents, id: \.id) { content in
                            HStack (spacing: 30){
                                content.image
                                    .resizable()
                                    .frame(width: 130, height: 170)
                                    .scaledToFit()
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(content.text)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: 120, alignment: .leading)
                                    
                                    Text(content.contentDateText)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: 120, alignment: .leading)
                                }
                                .padding(.vertical, 10)
                                
                                Image(systemName: "minus")
                                    .foregroundStyle(.red)
                                    .frame(height: 10)
                                    .background{
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke()
                                            .frame(width: 35, height: 35)
                                            .foregroundStyle(.white)
                                            .shadow(radius: 3)
                                    }
                                    .padding(.horizontal, 10)
                                    .onTapGesture {
                                        Task {
                                            selectedContent = content
                                            showAlert = true
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("게시물을 삭제하시겠어요?"),
                        message: Text("삭제 이후 작업을 되돌릴 수 없습니다"),
                        primaryButton: .default(Text("취소"), action: {
                            print("취소됨")
                        }),
                        secondaryButton: .destructive(Text("삭제"), action: {
                            if let contentToDelete = selectedContent {
                                Task {
                                    try await userViewModel.deleteContentImage(documentID: contentToDelete.id, email: authStore.user!.email)
                                    try await userViewModel.fetchContents(from: authStore.user!.email)
                                }
                            }
                        })
                    )
                }
            }
        }
        .navigationTitle("게시물 관리")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ImageManagementView()
}
