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
    private var geocoder: CLGeocoder
    private var locationManager: CLLocationManager
    @Published var region: MapCameraPosition
    @Published var currentAddress: String? // 주소를 저장할 프로퍼티
    
    override init() {
        geocoder = CLGeocoder() // Geocoder 초기화
        currentAddress = nil
        
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
            // 역지오코딩을 통해 주소 업데이트
            fetchAddress(for: newCoordinate)
        } else {
            // 위치를 가져올 수 없는 경우 처리 (필요시 알림 메시지 추가 가능)
            print("현재 위치를 가져올 수 없습니다.")
        }
    }
    
    // 역지오코딩을 사용해 좌표를 주소로 변환하는 메서드
    func fetchAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                self?.currentAddress = "주소를 찾을 수 없습니다."
                return
            }
            
            if let placemark = placemarks?.first {
                self?.currentAddress = self?.formatPlacemark(placemark)
            } else {
                self?.currentAddress = "주소를 찾을 수 없습니다."
            }
        }
    }
    
    // Placemark에서 주소를 형식화하는 메서드
    private func formatPlacemark(_ placemark: CLPlacemark) -> String {
        var addressString = ""
        
        if let locality = placemark.locality {
            addressString += locality
        }
        if let thoroughfare = placemark.thoroughfare {
            addressString += " \(thoroughfare)"
        }
        if let subThoroughfare = placemark.subThoroughfare {
            addressString += " \(subThoroughfare)"
        }
        
        return addressString
    }
    
    func updateRegion(to coordinate: CLLocationCoordinate2D) {
        region = MapCameraPosition.region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )
        // 좌표 변경 시, 역지오코딩도 호출
        fetchAddress(for: coordinate)
    }
}
