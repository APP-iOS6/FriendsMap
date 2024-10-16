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

struct UploadImageView: View {
    @EnvironmentObject private var ViewModels: UploadImageViewModel
    @EnvironmentObject var authStore: AuthenticationStore
    
    @Binding var selectedLatitude: Double?  // 메인 뷰로 보낼 위도 정보
    @Binding var selectedLongitude: Double? // 메인 뷰로 보낼 경도 정보
    
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
                                    ViewModels.extractMetadata(from: data)
                                    selectedImageData = data
                                    selectedLatitude = ViewModels.imagelatitude
                                    selectedLongitude = ViewModels.imagelongitude
                                }
                            }
                        }
                    
                    if uiImage != nil {
                        Button(action: {
                            Task {
                                await ViewModels.addImage(Content(id: UUID().uuidString, text: "오늘 날씨가 좋다", contentDate: ViewModels.imageDate ?? Date(), latitude: ViewModels.imagelatitude, longitude: ViewModels.imagelongitude), selectedImageData, authStore.user!.email)
                                dismiss()
                            }
                        }) {
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
    UploadImageView(selectedLatitude: .constant(nil), selectedLongitude: .constant(nil))
        .environmentObject(UploadImageViewModel())
}

