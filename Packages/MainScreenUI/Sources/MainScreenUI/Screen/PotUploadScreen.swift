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
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button {
                        
                        dismiss()
                        
                    } label: {
                        
                        Image(systemName: "x.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                        
                    }
                    .padding(.trailing, 20)
                }
                .frame(height: 50)
                
                SelectPhotoScreenComponent(screenModel: screenModel)
            }
            
                .navigationDestination(for: PotUploadDestination.self) { type in
                    
                    switch type {
                        
                    case .insertText:
                        InsetTextScreenComponent(screenModel: screenModel)
                        
                    }
                    
                }
            
        }
        
    }
    
}

#Preview {
    PotUploadScreen()
}
