//
//  MainView.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/14/24.
//

import SwiftUI
import MapKit

// Identifiable을 준수하는 구조체 정의
struct IdentifiableLocation: Identifiable {
    let id = UUID() // 고유 ID
    var coordinate: CLLocationCoordinate2D
}

struct MainView: View {
    @State private var isShowingSheet = false
    @State private var selectedLatitude: Double? = nil
    @State private var selectedLongitude: Double? = nil
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var signOut: AuthenticationStore
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    // 사용자가 선택한 사진의 위치가 있으면 해당 위치로 지도 표시
                    if let latitude = selectedLatitude, let longitude = selectedLongitude {
                        let location = IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.012, longitude: location.coordinate.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )), showsUserLocation: true, annotationItems: [location]) { location in
                            MapMarker(coordinate: location.coordinate, tint: .blue)
                        }
                        .edgesIgnoringSafeArea(.all)
                    } else {
                        // 사용자의 현재 위치로 지도 표시
                        Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
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
                            
                            // 현재 위치로 이동하는 버튼 추가
                            Button(action: {
                                selectedLatitude = nil // 선택된 위치 해제
                                selectedLongitude = nil
                                locationManager.updateRegionToUserLocation() // 현재 위치로 업데이트
                            }) {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, geometry.size.width * 0.03)
                            .padding(.top, geometry.size.width * 0.02) // 간격 조정
                            
                            // + 버튼
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
                                UploadImageView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude)
                                    .presentationDetents(selectedLatitude == nil ? [.fraction(0.2)] : [.medium])
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear {
//            signOut.signOut()
            Task {
               await mainViewModel.loadPosts()
            }
        }
    }
}


#Preview {
    MainView()
        .environmentObject(UploadImageViewModel())
        .environmentObject(MainViewModel())
}

