//
//  ProfileManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileManagementView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Circle()
                    .fill(.orange.gradient)
                    .frame(width: 200,height: 200)
                    .overlay {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    }
                Text("설정")
                
                List (0..<8) { index in
                    NavigationLink {
                        Text("\(index)")
                    }label: {
                        Text("설정 내용")
                    }
                }
                .listStyle(.inset)
            }
        }
    }
}

#Preview {
    ProfileManagementView()
}
