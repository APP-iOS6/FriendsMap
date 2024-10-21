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
//    @EnvironmentObject private var userViewModel: UserViewModel
    
    @Binding var selectedLatitude: Double?
    @Binding var selectedLongitude: Double?
    @Binding var annotations: [IdentifiableLocation]
    
    @State var imageSelection: PhotosPickerItem? = nil
    @State var uiImage: UIImage? = nil
    @State var selectedImageData: Data? = nil
    @State var text: String = ""
    @Environment(\.dismiss) var dismiss
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                HStack {
                    Button {
                        dismiss()
                    } label : {
                        Text("취소")
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()

                    
                    Text("새 게시글")
                        .fontWeight(.bold)
                        .font(.system(size: screenWidth * 0.05))
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        if uiImage != nil {
                            Task {
                                await authStore.addContent(Content(id: UUID().uuidString, text: text, contentDate: authStore.imageDate ?? Date(), latitude: authStore.imagelatitude, longitude: authStore.imagelongitude), selectedImageData, authStore.user.email)
                                
                                // 이미지를 업로드한 후, 사용자 데이터를 다시 로드
                                try await authStore.fetchContents(from: authStore.user.email)
                                
                                // 새로운 게시물 데이터를 기반으로 어노테이션을 업데이트
                                annotations = authStore.user.contents.map { post in
                                    IdentifiableLocation(coordinate: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude), image: post.image, email: authStore.user.email)
                                }
                                
                                // 업로드 후 지도 위치를 등록된 이미지의 위치로 이동
                                selectedLatitude = authStore.imagelatitude
                                selectedLongitude = authStore.imagelongitude

                                dismiss()
                            }
                        }
                    } label : {
                        Text("추가")
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal)
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: screenHeight * 0.2)
                } else {
                    Text("No Image")
                        .frame(width: screenWidth * 0.9, height: screenHeight * 0.2)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(.gray, style: StrokeStyle(lineWidth:1, dash: [20]))
                        }
                }
                
                PhotosPicker(
                    selection: $imageSelection,
                    matching: .images,
                    photoLibrary: .shared()) {
                        if imageSelection == nil {
                            HStack{
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("사진앱에서 가져오기")
                            }
                            .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                            .background(Color(red: 147/255, green: 147/255, blue: 147/255))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                        } else {
                            HStack{
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("사진 교체")
                            }
                            .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                            .background(Color(red: 147/255, green: 147/255, blue: 147/255))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                        }
                    }
                    .onChange(of: imageSelection) { _ , _  in
                        Task {
                            if let newSelection = imageSelection,
                               let data = try? await newSelection.loadTransferable(type: Data.self) {
                                uiImage = UIImage(data: data)
                                authStore.extractMetadata(from: data)
                                selectedImageData = data
                                selectedLatitude = authStore.imagelatitude
                                selectedLongitude = authStore.imagelongitude
                            }
                        }
                    }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: screenWidth * 0.9, height: screenHeight * 0.1)
                        .foregroundStyle(.gray.opacity(0.2))
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("\(text.count) / 50")
                                .foregroundStyle(text.count >= 50 ? .red : .gray)
                        }
                        .padding()
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.1)
                    
                    VStack(alignment : .center) {
                        TextField("내용을 입력해주세요", text: $text, axis: .vertical)
                            .frame(width: screenWidth * 0.85)
                            .padding()
                            .onChange(of: text) {
                                text = String(text.prefix(50))
                            }
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.1)
                }
                
                Spacer()
            }
            .frame(width: screenWidth, height: screenHeight)
            .background(.white)
        }
    }
}

#Preview {
    UploadingImageView(selectedLatitude: .constant(nil), selectedLongitude: .constant(nil), annotations: .constant([]))
        .environmentObject(UserViewModel())
}
