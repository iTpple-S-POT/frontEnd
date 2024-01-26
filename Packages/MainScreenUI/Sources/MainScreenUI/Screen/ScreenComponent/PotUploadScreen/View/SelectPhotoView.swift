//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import Photos
import CJPhotoCollection
import DefaultExtensions

struct SelectPhotoView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var screenModel: PotUploadScreenModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            Group {
                
                switch screenModel.authorizationStatus {
                    
                case .authorized:
                    Text("모든 사진에대한 접근권한")
                case .limited:
                    Text("제한된 접근")
                case .restricted:
                    Text("사진앱에 접근 불가한 디바이스입니다.")
                case .denied:
                    Text("접근이 제한되었습니다.")
                default:
                    Text("처리되지 못한 접근권한")
                }
                
            }
            .frame(height: 100)
            
            Picker("앨범선택", selection: $screenModel.selectedCollectionType) {
                
                ForEach(screenModel.collectionTypeList, id: \.self) { item in
                    
                    Text(item.title)
                    
                }
                
            }
            
            if screenModel.authorizationStatus == .authorized || screenModel.authorizationStatus == .limited {
                
                CJPhotoCollectionView(collectionType: $screenModel.selectedCollectionType) {
                    
                    // 이미지 데이터 획득 성공
                    if let imageInfo = $0 {
                        
                        screenModel.photoInformationUpdated(imageInfo: imageInfo)
                        
                        print("사진 선택 성공")
                        
                    } else {
                        
                        // 실패시 alert표시
                        screenModel.showImageDataUnavailable()
                        
                    }
                    
                } collectionTypesCompletion: {
                    
                    screenModel.collectionTypeList = $0
                    
                } dismissCompletion: {
                    
                    dismiss()
                    
                }

                
            } else {
                
                GeometryReader(content: { geo in
                    Text("접근할 수 있는 사진이 없습니다.")
                        .position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
                })
                
            }
            
        }
        .onAppear(perform: {
            screenModel.checkAuthorizationStatus()
        })
        .alert(isPresented: $screenModel.showAlert) {
            
            Alert(title: Text(screenModel.alertTitle), message: Text(screenModel.alertMessage), dismissButton: .default(Text("닫기")))
            
        }
    }
}

#Preview {
    SelectPhotoView()
        .environmentObject(PotUploadScreenModel())
}
