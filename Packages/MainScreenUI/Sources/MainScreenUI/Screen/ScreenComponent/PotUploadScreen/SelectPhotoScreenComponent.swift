//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import Photos
import CJPhotoCollection

struct SelectPhotoScreenComponent: View {
    
    @ObservedObject var screenModel: PotUploadScreenModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                
                if screenModel.authorizationStatus == .authorized {
                    
                    Text("모든 사진에대한 접근권한")
                    
                }
                
                if screenModel.authorizationStatus == .limited {
                    
                    Text("제한된 접근")
                    
                }
                
                if screenModel.authorizationStatus == .restricted {
                    
                    Text("사진앱에 접근 불가한 디바이스입니다.")
                    
                }
                
                if screenModel.authorizationStatus == .denied {
                    
                    Text("접근이 제한되었습니다.")
                    
                }
                
            }
            .frame(height: 100)
            
            Spacer(minLength: 0)
            
            if screenModel.authorizationStatus == .authorized || screenModel.authorizationStatus == .limited {
                
                CJPhotoCollectionView { screenModel.photoInformationUpdated(info: $0) }
                
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
    }
}

#Preview {
    SelectPhotoScreenComponent(screenModel: PotUploadScreenModel())
}
