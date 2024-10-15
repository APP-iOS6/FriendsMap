//
//  ImageManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ImageManagementView: View {
    @State private var contents: [Content] = Array(repeating: Content(image: Image(systemName: "photo"), text: "여기 진짜 지립니다 ㅋㅋ", likeCount: 3), count: 10)
    var body: some View {
        ScrollView {
            VStack {
                ForEach(contents.indices) { contentIndex in
                    HStack {
                        if let image = contents[contentIndex].image, let name = contents[contentIndex].text {
                            image
                                .resizable()
                                .frame(width: 100,height: 150)
                            Text(name)
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
                                    print("\(contentIndex + 1)")
                                    contents.remove(at: contentIndex + 1)
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ImageManagementView()
}
