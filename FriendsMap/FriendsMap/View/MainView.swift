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

    var body: some View {
        NavigationStack {
            ZStack {
                // 사용자가 선택한 사진의 위치가 있으면 해당 위치로 지도 표시
                if let latitude = selectedLatitude, let longitude = selectedLongitude {
                    let location = IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: location.coordinate,
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

                        // 현재 위치로 이동하는 버튼 추가
                        Button(action: {
                            // 사용자의 현재 위치로 지도를 이동
                            selectedLatitude = locationManager.region.center.latitude
                            selectedLongitude = locationManager.region.center.longitude
                        }) {
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 10) // 간격 조정

                        // + 버튼
                        Button(action: {
                            isShowingSheet = true
                        }) {
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
                        .sheet(isPresented: $isShowingSheet) {
                            UploadImageView(selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude)
                                .presentationDetents([.fraction(0.5)])
                        }
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
