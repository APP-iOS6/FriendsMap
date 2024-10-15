//
//  ImageManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ImageManagementView: View {
    @State private var contents: [Content] = Array(repeating: Content(id: "",image: "photo", text: "여기 진짜 지립니다 ㅋㅋ", likeCount: 3, contentDate: .now), count: 10)
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 70) {
                ForEach(viewModel.userContents, id: \.id) { content in
                    HStack {
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

#Preview {
    ImageManagementView()
}
