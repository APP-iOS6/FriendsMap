//
//  ProfileManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileManagementView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var authStore: AuthenticationStore
    
    @State private var profileImage: UIImage = UIImage()
    @State private var isPresented: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Button {
                    isPresented = true
                } label : {
                    ZStack {
                        if let photos = userViewModel.profile?.image {
                            AsyncImage(url: URL(string: photos)!) { image in
                                image.image?
                                    .resizable()
                                    .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                                    .clipShape(Circle())
                                    .aspectRatio(contentMode: .fit)
                            }
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.gray)
                                .offset(x : screenWidth * 0.13, y : screenHeight * 0.055)
                        }
                    }
                }
                if let nickname = userViewModel.profile?.nickname {
                    Text(nickname)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                }
                //                Text("설정")
                //
                //                List (0..<8) { index in
                //                    NavigationLink {
                //                        Text("\(index)")
                //                    }label: {
                //                        Text("설정 내용")
                //                    }
                //                }
                //                .listStyle(.inset)
                
                Spacer()
                
                Button {
                    Task {
                        let imageData = profileImage.jpegData(compressionQuality: 0.8)
                        let result = await authStore.updateProfile(nickname: userViewModel.profile?.nickname ?? "", image: imageData, email: authStore.user!.email)
                        if result {
                            print("업데이트 성공")
                        } else {
                            print("업데이트 안됨")
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: screenWidth * 0.5, height: screenHeight * 0.06)
                            .foregroundStyle(Color(red: 147/255, green: 147/255, blue: 147/255))
                        Text("변경하기")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, screenHeight * 0.15)
                }
                
                .padding(.horizontal, 27)
            }
            .frame(width:screenWidth, height: screenHeight)
            .background(.loginViewBG)
            .sheet(isPresented: $isPresented) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileImage)
                    .onChange(of: profileImage) { _, _ in
                        
                    }
            }
        }
    }
}
#Preview {
    ProfileManagementView()
}
