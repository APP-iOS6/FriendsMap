//
//  MainView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/14/24.
//

import SwiftUI
import MapKit

struct MainView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Map()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .padding(.leading, 20)

                        Spacer()

                        Button(action: {
                            print("Move to My Page")
                        }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 20)

                    Spacer()

                    HStack {
                        Spacer()

                        NavigationLink(destination: UploadImageView()) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true) 
        }
    }
}

#Preview {
    MainView()
}
