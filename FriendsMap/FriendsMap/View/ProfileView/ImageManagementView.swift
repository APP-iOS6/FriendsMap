//
//  ImageManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ImageManagementView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        ZStack {
            Color.loginViewBG.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 70) {
                    ForEach(viewModel.userContents, id: \.id) { content in
                        HStack (spacing: 50){
                            AsyncImage(url: URL(string: content.image!)) { image in
                                if let image = image.image {
                                    image.resizable()
                                        .frame(width: 100,height: 200)
                                        .scaledToFit()
                                }
                            }
                            
                            Text("\(content.text!)")
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
                                        try await viewModel.deleteContentImage(documentID: content.id, email: "j77777y@naver.com")
                                        try await viewModel.fetchContents(from: "j77777y@naver.com")
                                    }
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    Task {
                        try await viewModel.fetchContents(from: "j77777y@naver.com")
                    }
                }
            }
        }
    }
}

#Preview {
    ImageManagementView()
}
