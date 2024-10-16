
//  FriendRequestView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/15/24.
//
import SwiftUI

struct FriendRequestsView: View {
    @StateObject var viewModel: FriendViewModel
    
    var body: some View {
        VStack {
            Text("받은 친구 요청")
                .font(.system(size: 18))
                .bold()
                .foregroundStyle(Color.white)
                .padding()
            List(viewModel.receiveList, id: \.self) { requestEmail in
                HStack {
                    Text(requestEmail)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        Task {
                            await viewModel.acceptFriendRequest(from: requestEmail)
                        }
                    }) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .background(Color(hex: "#404040"))
            .scrollContentBackground(.hidden)
        }
        .background(Color(hex: "#404040").ignoresSafeArea())
    }
}
