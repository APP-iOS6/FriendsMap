//
//  ProfileManagementView.swift
//  FriendsMap
//
//  Created by Soom on 10/15/24.
//

import SwiftUI

struct ProfileManagementView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Circle()
                    .fill(.gray.opacity(0.75))
                    .frame(width: 200,height: 200)
                
                Text("설정")
                
                List (0..<8) { index in
                    NavigationLink {
                        Text("\(index)")
                    }label: {
                        Text("\(index)")
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
