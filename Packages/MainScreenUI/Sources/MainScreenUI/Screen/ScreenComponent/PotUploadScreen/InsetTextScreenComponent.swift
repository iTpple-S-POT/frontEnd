//
//  InsetTextScreenComponent.swift
//
//
//  Created by 최준영 on 2024/01/03.
//

import SwiftUI
import GlobalObjects

struct InsetTextScreenComponent: View {
    
    @ObservedObject var screenModel: PotUploadScreenModel
    
    var body: some View {
        ZStack {
            
            VStack {    
                
                HStack {
                    
                    Spacer()
                    
                    Button("팟 업로드") {
                        
                        if let info = screenModel.imageInfo {
                         
                            APIRequestGlobalObject.shared.uploadPot(imageInfo: info)
                            
                        }
                        
                    }
                    .padding(.trailing, 20)
                    
                }
                
                Spacer()
                
            }
            
            TextField("팟 텍스트 입력", text: $screenModel.potText, prompt: Text("메세지 입력"))
                .padding(.horizontal, 20)
                .background(
                    Rectangle()
                        .fill(.gray.opacity(0.5))
                )
                .zIndex(1)
            
        }
            
    }
}

#Preview {
    InsetTextScreenComponent(screenModel: PotUploadScreenModel())
}
