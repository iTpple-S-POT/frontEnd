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
            
            SelectCategoryScreenComponent()
            
            //                .navigationDestination(for: PotUploadDestination.self) { type in
            //
            //                    switch type {
            //
            //                    case .insertText:
            //                        InsetTextScreenComponent(screenModel: screenModel)
            //
            //                    }
            //
            //                }
            
        }
        .environmentObject(screenModel)
        .onAppear { screenModel.dismiss = dismiss }
        
    }
    
}

#Preview {
    PotUploadScreen()
}
