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
    
    @State private var showCameraView = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                HStack(spacing: 0) {
                    
                    Spacer(minLength: 28)
                    
                    
                    Menu {
                        
                        Picker(selection: $screenModel.selectedCollectionType) {
                            
                            ForEach(screenModel.collectionTypeList, id: \.self) { item in
                                
                                Text(item.title)
                                
                            }
                            
                        } label: { EmptyView() }
                        
                    } label: {
                        
                        HStack {
                            
                            Text("\(screenModel.selectedCollectionType.title)")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Image(systemName: "chevron.up.chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                        .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                }
                
                HStack(spacing: 0) {
                    
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .padding(.horizontal, 10)
                        .onTapGesture(perform: { dismiss() })
                    
                    Spacer(minLength: 0)
                    
                }
                
            }
            .padding(.horizontal, 21)
            .frame(height: 56)
            .background(
                Rectangle().fill(.white)
            )
            .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
            
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
                    
                } selectCameraCompletion: {
                    
                    // 카메라 스크린 표시
                    showCameraView = true
                }
                collectionTypesCompletion: {
                    
                    screenModel.collectionTypeList = $0
                    
                } dismissCompletion: {
                    
                    dismiss()
                }
                .ignoresSafeArea(.all, edges: .bottom)

                
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
        .fullScreenCover(isPresented: $showCameraView) {
            SpotCameraView()
        }
    }
}

#Preview {
    SelectPhotoView()
        .environmentObject(PotUploadScreenModel())
}
