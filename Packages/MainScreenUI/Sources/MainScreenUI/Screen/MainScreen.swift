//
//  MainScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI
import GlobalObjects

public struct MainScreen: View {
    
    @StateObject var screenModel = MainScreenModel()
    
    public init() { }
    
    public var body: some View {
        ZStack {
            
            // 상단
            VStack(spacing: 0) {
                
                TopMostScreenComponent()
                    .frame(height: 56)
                
                SelectMapTagScreenComponent()
                    .frame(height: 88)
                
                Spacer(minLength: 0)
                
            }
            .zIndex(1)
            
            
            ZStack {
                MapScreenComponent()
            }
            .padding(.top, 56)
            .padding(.bottom, 64)
            .zIndex(0)
            
            // 하단
            VStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                TabScreenComponent(mainScreenModel: screenModel)
                    .frame(height: 64)
            }
            .zIndex(1)
            
        }
        .alert(isPresented: $screenModel.showAlert) {
            
            Alert(title: Text(screenModel.alertTitle), message: Text(screenModel.alertMessage), dismissButton: .default(Text("닫기")))
            
        }
    }
}

class MainScreenModel: ObservableObject {
    
    // 데이터를 받을 수 없는 사진의 경우 Alert표시
    @Published var showAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    func showPotUploadSuccess() {
        
        showAlert = true
        alertTitle = "업로드 성공"
        alertMessage = "팟이 성공적으로 업로드됨"
    }
    
    func showPotUploadFailed() {
        
        showAlert = true
        alertTitle = "업로드 실패"
        alertMessage = "팟을 업로드하지 못했습니다."
    }
    
}


#Preview {
    MainScreen()
}
