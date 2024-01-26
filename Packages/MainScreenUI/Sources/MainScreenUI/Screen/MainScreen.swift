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
        .environmentObject(screenModel)
    }
}

#Preview {
    MainScreen()
}
