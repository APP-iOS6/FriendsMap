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

extension CLLocationCoordinate2D {
    static let imageCoordinate = CLLocationCoordinate2D(latitude: 37.658301, longitude: 126.831972)
}

struct UploadImageView: View {
    @Binding var selectedLatitude: Double?  // 메인 뷰로 보낼 위도 정보
    @Binding var selectedLongitude: Double? // 메인 뷰로 보낼 경도 정보
    
    @State private var position: MapCameraPosition = .automatic // 카메라 위치
    @State var imageSelection: PhotosPickerItem? = nil
    @State var uiImage: UIImage? = nil
    @State var metadata: [String: Any] = [:] // 메타데이터 저장
    @State var imagelatitude: Double = 0.0
    @State var imagelongitude: Double = 0.0
    @State var imageDate: Date?
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    HStack {
                        if let uiImage = uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.3)
                        }
                        
                        VStack {
                            Text("사진 이름")
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.05)
                                .background(.gray)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            
                            PhotosPicker(
                                selection: $imageSelection,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    Text("사진 변경하기")
                                        .frame(width: 200, height: 50)
                                        .background(.blue)
                                        .foregroundStyle(.white)
                                        .cornerRadius(10)
                                }
                                .onChange(of: imageSelection) { _ , _  in 
                                    Task {
                                        // imageSelection의 현재 값을 확인하여 데이터를 로드
                                        if let newSelection = imageSelection,
                                           let data = try? await newSelection.loadTransferable(type: Data.self) {
                                            uiImage = UIImage(data: data)
                                            
                                            // 메타데이터 추출
                                            extractMetadata(from: data)
                                        }
                                    }
                                }


                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    if uiImage != nil {
                        Button(action: {
                            // 선택된 위치 정보를 메인 뷰로 전달
                            selectedLatitude = imagelatitude
                            selectedLongitude = imagelongitude
                        }) {
                            Text("등록하기")
                                .frame(width: geometry.size.width * 0.8, height: 50)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .navigationTitle("사진 등록하기")
            }
        }
    }
    
    // 메타데이터 추출 함수
    func extractMetadata(from data: Data) {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("이미지 소스를 생성할 수 없습니다.")
            return
        }
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] {
            metadata = properties
            print("메타데이터: \(metadata)") // 메타데이터 확인용 출력
            
            if let gpsData = metadata["{GPS}"] as? [String: Any] {
                if let latitude = gpsData["Latitude"] as? Double,
                   let latitudeRef = gpsData["LatitudeRef"] as? String,
                   let longitude = gpsData["Longitude"] as? Double,
                   let longitudeRef = gpsData["LongitudeRef"] as? String {
                    
                    // 위도 및 경도를 북위/남위, 동경/서경을 반영하여 처리
                    let lat = (latitudeRef == "N" ? latitude : -latitude)
                    let lon = (longitudeRef == "E" ? longitude : -longitude)
                    
                    print("위도: \(lat), 경도: \(lon)")
                    
                    imagelatitude = lat
                    imagelongitude = lon
                    // 메인 뷰의 latitude, longitude 업데이트
                    selectedLatitude = lat
                    selectedLongitude = lon
                    position = .automatic
<<<<<<< Updated upstream
                    
                } else {
                    print("위치 정보가 없습니다.")
                }
                
                // Exif 데이터에서 날짜 정보 추출
                if let exifData = metadata["{Exif}"] as? [String: Any],
                   let dateString = exifData["DateTimeOriginal"] as? String {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy:MM:dd HH:mm:ss" // Exif 날짜 형식
                    if let date = formatter.date(from: dateString) {
                        imageDate = date
                        print("촬영 날짜: \(date)")
                    } else {
                        print("날짜 형식을 변환할 수 없습니다.")
                    }
                } else {
                    print("날짜 정보가 없습니다.")
=======
>>>>>>> Stashed changes
                }
            }
        } else {
            print("메타데이터를 추출할 수 없습니다.")
        }
    }
}

#Preview {
    UploadImageView(selectedLatitude: .constant(nil), selectedLongitude: .constant(nil))
}
