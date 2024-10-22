//
//  MainView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/14/24.
//

import SwiftUI
import MapKit


struct MainView: View {
    @State private var isShowingUploadSheet = false // 업로드 이미지 시트 표시
    @State private var isShowingDetailSheet = false // 이미지 디테일 시트 표시
    @State private var selectedLatitude: Double? = nil
    @State private var selectedLongitude: Double? = nil
    @State private var annotations: [IdentifiableLocation] = []
    
    @State private var selectedImageUrl: String? = nil // 선택된 이미지를 추적
    
    @StateObject private var locationManager = LocationManager()
//    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject var authStore: AuthenticationStore
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    if let latitude = selectedLatitude, let longitude = selectedLongitude {
                        let location = IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), image: Image(systemName: "person.crop.circle"), email: authStore.user.email)
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.012, longitude: location.coordinate.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
                        )), showsUserLocation: true, annotationItems: annotations) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                VStack {
                                    location.image
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                    
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                    } else {
                        Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: annotations) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                VStack {
                                    location.image
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                    
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                    
                    VStack {
                        HStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.2)
                                .padding(.leading, geometry.size.width * 0.05)
                            
                            Spacer()
                            
                            NavigationLink {
                                ProfileView()
                            } label: {
                                VStack {
                                    authStore.user.profile.image
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, geometry.size.width * 0.05)
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                selectedLatitude = nil
                                selectedLongitude = nil
                                locationManager.updateRegionToUserLocation()
                            }) {
                                Image(systemName: "dot.scope")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, geometry.size.width * 0.03)
                            .padding(.top, geometry.size.width * 0.02)
                            
                            Button(action: {
                                selectedImageUrl = nil // 이미지 선택 초기화
                                isShowingUploadSheet = true // 업로드 이미지 시트 표시
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, geometry.size.width * 0.03)
                            .padding(.top, geometry.size.width * 0.02)
                        }
                        .onAppear {
                            Task {
                                try await authStore.fetchContents(from: authStore.user.email)
                                // 로드된 데이터를 기반으로 어노테이션 설정
                                await authStore.fetchProfile(authStore.user.email)
                                await authStore.loadFriendData()
                                annotations = authStore.user.contents.map { post in
                                    IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude), image: post.image, email: authStore.user.email)
                                }
                                
                                for friend in authStore.user.friends {
                                    try await authStore.fetchFriendContents(from: friend)
                                    for content in authStore.friendContents {
                                        annotations.append(IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: content.latitude, longitude: content.longitude), image: content.image, email: friend))
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
            // 업로드 이미지 시트
            .sheet(isPresented: $isShowingUploadSheet) {
                UploadingImageView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude, annotations: $annotations)
                    .presentationDetents([.height(screenHeight * 0.5)]) // 수정된 부분
            }
            // 이미지 디테일 시트
            .sheet(isPresented: $isShowingDetailSheet) {
                if let selectedImageUrl = selectedImageUrl {
                    ContentDetailView(imageUrl: selectedImageUrl) // ImageDetailView로 시트 표시
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthenticationStore())
}
