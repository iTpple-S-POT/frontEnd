//
//  PotUploadScreen.swift
//
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import Photos
import CJPhotoCollection

struct PotUploadScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var screenModel = PotUploadScreenModel()
    
    
    var body: some View {
        
        NavigationStack(path: $screenModel.navigationStack) {
            
            // 카테고리 선택(Root)
            SelectCategoryScreenComponent()
            
                .navigationDestination(for: PotUploadDestination.self) { type in
                    
                    switch type {
                        
                    case .uploadScreen:
                        UploadScreenComponent()
                            .navigationBarBackButtonHidden()
                    case .hashTagScreen:
                        HashTagScreenComponent()
                            .navigationBarBackButtonHidden()
                    case .finalScreen:
                        Text("업로드 직전 스크린")
                            .navigationBarBackButtonHidden()
                    }
                    
                }
            
        }
        .environmentObject(screenModel)
        .onAppear { screenModel.dismiss = dismiss }
        
    }
    
}

#Preview {
    PotUploadScreen()
}
