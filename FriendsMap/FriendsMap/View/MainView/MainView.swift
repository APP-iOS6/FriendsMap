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
    @EnvironmentObject var authStore: AuthenticationStore
    
    @State var selectEmail: String = "" // 선택한 유저 이메일
    @State var tripRoute: [CLLocationCoordinate2D] = [] // 루트 순서 저장용
    
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Map (position: $locationManager.region) {
                        ForEach(annotations) { annotation in
                            Annotation("", coordinate: annotation.coordinate) {
                                annotation.image
                                    .resizable()
                                    .frame(width: 100,height: 100)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedImageUrl = annotation.contentId
                                        tripRoute = filterMaps(annotation.email)
                                        selectEmail = annotation.email
                                        isShowingDetailSheet = true
                                    }
                            }
                        }
                        
                        if !selectEmail.isEmpty {
                            MapPolyline(coordinates: tripRoute)
                                .stroke(.blue, lineWidth: 5)
                        }
                    }
                    .task {
                        do {
                            try await authStore.fetchContents(from: authStore.user.email)
                            await authStore.fetchProfile(authStore.user.email)
                            await authStore.loadFriendData()
            
                            annotations = authStore.user.contents.map { post in
                                IdentifiableLocation(contentId: post.id, coordinate: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude), image: post.image, email: authStore.user.email, date: post.contentDate)
                            }
                            for friend in authStore.user.friends {
                                try await authStore.fetchFriendContents(from: friend)
                                for content in authStore.friendContents {
                                    annotations.append(IdentifiableLocation(contentId: content.id, coordinate: CLLocationCoordinate2D(latitude: content.latitude, longitude: content.longitude), image: content.image, email: friend, date: content.contentDate))
                                }
                            }
                        } catch {
                            print("error: \(error.localizedDescription)")
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    
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
                            
                            Button {
                                locationManager.updateRegionToUserLocation()
                            }label: {
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
                        
                    }
                    .navigationBarHidden(true)
                }
            }

            // 업로드 이미지 시트
            .sheet(isPresented: $isShowingUploadSheet) {
                UploadingImageView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude, annotations: $annotations, position: $locationManager.region)
                    .presentationDetents([.height(screenHeight * 0.5)]) // 수정된 부분
            }
            // 이미지 디테일 시트
            .sheet(isPresented: $isShowingDetailSheet) {
                if let selectedImageUrl = selectedImageUrl {
                    // selectedImageUrl을 콘텐츠 ID로 사용
                    ContentDetailView(contentId: selectedImageUrl)
                        .environmentObject(authStore)
                }

            }

        }
    }
}

extension MainView {
    func filterMaps(_ email: String) -> [CLLocationCoordinate2D]{
        var filteredAnnotation = annotations.filter {
            $0.email == email
        }.sorted {$0.date < $1.date}
        
        return filteredAnnotation.map({ CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
        })
    }
}
