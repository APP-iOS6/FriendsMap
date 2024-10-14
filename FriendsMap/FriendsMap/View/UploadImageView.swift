//
//  UploadImageView.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI
import MapKit

struct UploadImageView: View {

    var body: some View {
        NavigationStack {
            VStack {
                Map()
                Text("Hello, World!")
            }
            .navigationTitle("사진 등록하기")
        }
    }
}

#Preview {
    UploadImageView()
}
