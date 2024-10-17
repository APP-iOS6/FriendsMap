//
//  UploadImageView.swift
//  FriendsMap
//
//  Created by 박준영 on 10/14/24.
//

import SwiftUI
import MapKit
import PhotosUI
import ImageIO

struct UploadingImageView: View {
    @EnvironmentObject private var authStore: AuthenticationStore
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @Binding var selectedLatitude: Double?  // 메인 뷰로 보낼 위도 정보
    @Binding var selectedLongitude: Double? // 메인 뷰로 보낼 경도 정보
    @Binding var annotations: [IdentifiableLocation]
    
    @State var imageSelection: PhotosPickerItem? = nil
    @State var uiImage: UIImage? = nil
    @State var selectedImageData: Data? = nil
    @Environment(\.dismiss) var dismiss
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Text("게시글 생성")
                    .fontWeight(.bold)
                    .font(.system(size: screenWidth * 0.07))
                    .padding()
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: screenHeight * 0.2)
                }
                
                HStack(alignment: .center) {
                    PhotosPicker(
                        selection: $imageSelection,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if imageSelection == nil {
                                HStack{
                                    Image(systemName: "photo.on.rectangle.angled")
                                    Text("사진앱에서 가져오기")
                                }
                                .frame(width: screenWidth * 0.85, height: screenHeight * 0.06)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            } else {
                                HStack{
                                    Image(systemName: "photo.on.rectangle.angled")
                                    Text("사진 교체")
                                }
                                .frame(width: screenWidth * 0.4, height: screenHeight * 0.06)
                                .background(.green)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            }
                        }
                        .onChange(of: imageSelection) { _ , _  in
                            Task {
                                if let newSelection = imageSelection,
                                   let data = try? await newSelection.loadTransferable(type: Data.self) {
                                    uiImage = UIImage(data: data)
                                    userViewModel.extractMetadata(from: data)
                                    selectedImageData = data
                                    selectedLatitude = userViewModel.imagelatitude
                                    selectedLongitude = userViewModel.imagelongitude
                                }
                            }
                        }
                    
                    if uiImage != nil {
                        Button {
                            Task {
                                await userViewModel.addImage(Content(id: UUID().uuidString, text: "오늘 날씨가 좋다", contentDate: userViewModel.imageDate ?? Date(), latitude: userViewModel.imagelatitude, longitude: userViewModel.imagelongitude), selectedImageData, authStore.user!.email)
                                dismiss()
                                try await userViewModel.fetchContents(from: authStore.user?.email ?? "")
                                annotations = userViewModel.userContents.map { post in
                                    IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude), image: post.image)
                                }
//                                print("\(userViewModel.userContents.count)")
                            }
                        } label: {
                            Text("등록하기")
                                .frame(width: screenWidth * 0.4, height: screenHeight * 0.06)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                Spacer() // 하단 여백
            }
            .frame(width: screenWidth, height: screenHeight)
            .background(Color.white) // 배경색 설정 (필요시)
        }
    }
}

#Preview {
    UploadingImageView(selectedLatitude: .constant(nil), selectedLongitude: .constant(nil), annotations: .constant([]))
        .environmentObject(UserViewModel())
}

