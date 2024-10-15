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
    @Published var region: MKCoordinateRegion

    override init() {
        locationManager = CLLocationManager()
        // 초기값을 서울로 설정
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.978), // 서울의 위도와 경도
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        super.init()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 사용자의 현재 위치와 region.center가 다를 경우에만 업데이트
        let newCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if region.center.latitude != newCoordinate.latitude || region.center.longitude != newCoordinate.longitude {
            region.center = newCoordinate
        }
    }
}
