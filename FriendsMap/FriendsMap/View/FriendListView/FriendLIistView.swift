//
//  FriendLIistView.swift
//  FriendsMap
//
//  Created by 박범규 on 10/16/24.
//


import SwiftUI

struct FriendListView: View {
    @StateObject var viewModel = FriendViewModel()
    
    var body: some View {
        NavigationView {
            NavigationView {
                ZStack {
                    Color(hex: "#404040")
                        .ignoresSafeArea()
                    VStack {
                        Text("친구 목록")
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .padding()
                        // Friends List
                        List(viewModel.friends, id: \.self) { friend in
                            Text("\(friend)")
                                .foregroundColor(.black)
                                .padding()
                        }
                        .background(Color(hex: "#404040"))
                        .scrollContentBackground(.hidden)
                        .foregroundColor(.white)
                        
                        Spacer()
                        Spacer()
                        // Actions
                        HStack {
                            Spacer()
                            
                            // Add Friend Button
                            NavigationLink(destination: AddFriendView(viewModel: viewModel)) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .padding()
                            }
                            .padding(.trailing, 20)
                            
                        }
                    }
                    .navigationBarTitle("")
                    .onAppear {
                        Task {
                            await viewModel.loadFriendData()
                        }
                    }
                }
                .background(Color(hex: "#404040").ignoresSafeArea())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendRequestsView(viewModel: viewModel)) {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
