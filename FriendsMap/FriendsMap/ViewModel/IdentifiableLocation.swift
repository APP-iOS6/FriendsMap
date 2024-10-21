//
//  IdentifiableLocation.swift
//  FriendsMap
//
//  Created by Juno Lee on 10/21/24.
//

import Foundation
import CoreLocation
import SwiftUI


public struct IdentifiableLocation: Identifiable {
    public let id = UUID()
    public var coordinate: CLLocationCoordinate2D
    public var image: Image
    public var email: String // 작성자 구분용

  
//    public init(coordinate: CLLocationCoordinate2D, image: String? = nil) {
//        self.coordinate = coordinate
//        self.image = image
//    }
}

