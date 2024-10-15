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
    
    @Binding var selectedLatitude: Double?  // 메인 뷰로 보낼 위도 정보
    @Binding var selectedLongitude: Double? // 메인 뷰로 보낼 경도 정보
    
    @State var imageSelection: PhotosPickerItem? = nil
    @State var uiImage: UIImage? = nil
    @State var selectedImageData: Data? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    PhotosPicker(
                        selection: $imageSelection,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if imageSelection == nil {
                                HStack{
                                    Image(systemName: "photo.on.rectangle.angled")
                                    Text("갤러리에서 사진 가져오기")
                                }
                                .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.1)
                                .frame(minHeight: geometry.size.height * 0.1, maxHeight: geometry.size.height * 0.2)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            } else {
                                HStack{
                                    Image(systemName: "photo.on.rectangle.angled")
                                    Text("사진 교체")
                                }
                                .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.1)
                                .frame(minHeight: geometry.size.height * 0.1, maxHeight: geometry.size.height * 0.2)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            }
                        }
                        .onChange(of: imageSelection) { _ , _  in
                            Task {
                                // imageSelection의 현재 값을 확인하여 데이터를 로드
                                if let newSelection = imageSelection,
                                   let data = try? await newSelection.loadTransferable(type: Data.self) {
                                    uiImage = UIImage(data: data)
                                    
                                    // 메타데이터 추출
                                    ViewModels.extractMetadata(from: data)
                                    selectedImageData = data
                                    
                                    selectedLatitude = ViewModels.imagelatitude
                                    selectedLongitude =
                                    ViewModels.imagelongitude
                                }
                            }
                        }
                    Spacer()
                }
                .frame(width: .infinity)
                
                if uiImage != nil {
                    Button(action: {
                        Task {
                            await ViewModels.addImage(Content(text: "오늘 날씨가 좋다", contentDate: ViewModels.imageDate ?? Date(), latitude: ViewModels.imagelatitude, longitude: ViewModels.imagelongitude), selectedImageData)
                        }
                    }) {
                        Text("등록하기")
                            .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.1)
                            .frame(minHeight: geometry.size.height * 0.1, maxHeight: geometry.size.height * 0.2)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    UploadImageView(selectedLatitude: .constant(nil), selectedLongitude: .constant(nil))
        .environmentObject(UploadImageViewModel())
}
