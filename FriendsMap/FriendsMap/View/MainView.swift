//
//  MainView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/14/24.
//

import SwiftUI
import MapKit


struct IdentifiableLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var image: String?
}

struct MainView: View {
    @State private var isShowingSheet = false
    @State private var selectedLatitude: Double? = nil
    @State private var selectedLongitude: Double? = nil
    @State private var annotations: [IdentifiableLocation] = []
    
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject private var userViewModel: UserViewModel
        @EnvironmentObject var authStore: AuthenticationStore
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    if let latitude = selectedLatitude, let longitude = selectedLongitude {
                        let location = IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.012, longitude: location.coordinate.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )), showsUserLocation: true, annotationItems: annotations) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                VStack {
                                    if let imageUrl = location.image, let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
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
                                    if let imageUrl = location.image, let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
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
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, geometry.size.width * 0.05)
                        }
                        .padding(.top, geometry.size.width * 0.02)
                        
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
                                isShowingSheet = true
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
                            .sheet(isPresented: $isShowingSheet) {
                                UploadingImageView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude, annotations: $annotations)
                                    .presentationDetents(selectedLatitude == nil ? [.fraction(screenHeight * 0.0002)] : [.fraction(screenHeight * 0.0005)])
                            }
                        }
                    }
                    .onAppear {
                        Task {
                            try await userViewModel.fetchContents(from: authStore.user?.email ?? "")
                            // 로드된 데이터를 기반으로 어노테이션 설정
                            annotations = userViewModel.userContents.map { post in
                                IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude), image: post.image)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
        
    }
}

#Preview {
    MainView()
        .environmentObject(UserViewModel())
    //        .environmentObject(AuthenticationStore())
}
