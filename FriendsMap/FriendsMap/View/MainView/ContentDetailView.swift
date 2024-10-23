//
//  ImageDetailView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/21/24.
//

import SwiftUI
import CoreLocation

struct ContentDetailView: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @Binding var annotations: [IdentifiableLocation]
    
    let identifiableLocation: IdentifiableLocation
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                identifiableLocation.image
                    .resizable()
                    .aspectRatio(contentMode: .fit) 
                    .frame(width: 600, height: 600)
                    .cornerRadius(10)
                
                Text(identifiableLocation.date.formatted(.dateTime))
                    .font(.title3)
                
                Text(identifiableLocation.email)
                    .font(.title3)
            }
        }
    }
}



struct PolaroidImageView: View {
    let image: Image
    let text: String
    let date: String
    let nickName: String
    let profileImage: Image
    
    @State private var isLiked: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    image
                        .resizable()
                        .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                    
                    Text(nickName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(8)
                    
                    Spacer()
                    
                    Text("\(date)")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing], 12)
                    
                }.padding(.horizontal)
                
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: min(geometry.size.width * 0.7, 380), height: 400)
                        .cornerRadius(5)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(text)
                                .font(.body)
                                .padding(.leading, 12)
                                .padding(.trailing, 12)
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            Text("사진 찍은 주소 ........")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding([.leading, .trailing], 12)
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                        
                        Button(action: {
                            isLiked.toggle()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .gray)
                                .font(.title)
                                .padding()
                        }
                    }.padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // GeometryReader의 크기를 맞춤
        }
        .padding(.horizontal) // 좌우 여백 추가
    }
}
