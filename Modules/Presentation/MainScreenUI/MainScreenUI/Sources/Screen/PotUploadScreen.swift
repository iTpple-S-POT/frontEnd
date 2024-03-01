//
//  PotUploadScreen.swift
//
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import Photos
import CJPhotoCollection
import Combine

struct PotUploadScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var screenModel = PotUploadScreenModel()
    
    var uploadCompletion: (Bool) -> ()
    
    @State var uploadSub: AnyCancellable?
    
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
                        FinalPotScreenComponent()
                            .navigationBarBackButtonHidden()
                    case .photoCollection:
                        SelectPhotoView()
                            .navigationBarBackButtonHidden()
                    }
                    
                }
            
        }
        .environmentObject(screenModel)
        .onAppear {
            screenModel.dismiss = dismiss
                
            self.uploadSub = screenModel.potUploadPublisher.sink { uploadCompletion($0) }
        }
        
    }
    
}

#Preview {
    PotUploadScreen { result in
        
    }
}
