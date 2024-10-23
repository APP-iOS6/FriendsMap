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
                    .scaledToFit()
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
