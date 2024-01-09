//
//  InsetTextScreenComponent.swift
//
//
//  Created by 최준영 on 2024/01/03.
//

import SwiftUI
import GlobalObjects

struct InsetTextScreenComponent: View {
    
    @EnvironmentObject var mainNavigation: MainNavigation
    
    @ObservedObject var screenModel: PotUploadScreenModel
    
    var body: some View {
        ZStack {
            
            VStack {    
                
                HStack {
                    
                    Spacer()
                    
                    Button("팟 업로드") {
                        
                        do {
                            try screenModel.uploadPot()
                        } catch {
                            
                            if let prepareError = error as? PotUploadPrepareError {
                                
                                if prepareError == .cantGetUserLocation {
                                    
                                    print("권한")
                                    
                                }
                                
                            }
                            
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
        .padding(.horizontal, 20)
        .alert(isPresented: $screenModel.showAlert) {
            Alert(title: Text(screenModel.alertTitle), message: Text(screenModel.alertMessage), dismissButton: .default(Text("닫기"), action: {
                
                mainNavigation.popTopView()
                
            }))
        }
            
    }
}

#Preview {
    InsetTextScreenComponent(screenModel: PotUploadScreenModel())
        .environmentObject(MainNavigation())
}
