//
//  LocationManager.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/15/24.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    @Published var region: MapCameraPosition

    override init() {
        locationManager = CLLocationManager()
        // 초기값을 서울로 설정
        region = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.978),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )

        super.init()
        

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    // 사용자의 현재 위치로 지도를 이동하는 메서드
    func updateRegionToUserLocation() {
        if let currentLocation = locationManager.location {
            let newCoordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            region = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: newCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        } else {
            // 위치를 가져올 수 없는 경우 처리 (필요시 알림 메시지 추가 가능)
            print("현재 위치를 가져올 수 없습니다.")
        }
    }
    
    func updateRegion(to coordinate: CLLocationCoordinate2D) {
        region = MapCameraPosition.region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )
    }
}
