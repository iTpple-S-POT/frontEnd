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
                        
                        uploadPot()
                        
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
                
                // TODO: 업로드 실패시
                
            }))
        }
            
    }
}

extension InsetTextScreenComponent {
    
    func uploadPot() {
        
        Task {
            
            do {
                
                // 팟업로드 시작
                try await screenModel.uploadPot()
                
            } catch {
                
                if let prepareError = error as? PotUploadPrepareError {
                    
                    print("팟 업로드 준비중 실패, \(prepareError)")
                    
                    switch prepareError {
                    case .cantGetUserLocation( _ ):
                        screenModel.showLocationAuthorizationError()
                    case .imageInfoDoesntExist( _ ):
                        screenModel.showImageDoesntLoaded()
                    }
                    
                }
                
                if let netError = error as? SpotNetworkError {
                    
                    print("팟 업로드 실패, \(netError)")
                    
                    screenModel.showNetworkError(errorCase: netError)
                    
                }
                
            }
            
        }
        
    }

}

#Preview {
    InsetTextScreenComponent(screenModel: PotUploadScreenModel())
        .environmentObject(MainNavigation())
}
