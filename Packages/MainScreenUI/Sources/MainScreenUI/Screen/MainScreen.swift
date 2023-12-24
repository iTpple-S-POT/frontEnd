//
//  MainScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        ZStack {
            
            // 상단
            VStack(spacing: 0) {
                TopMostScreenComponent()
                    .frame(height: 56)
                SelectMapTagScreenComponent()
                    .frame(height: 64)
                
                Spacer(minLength: 0)
                
            }
            .zIndex(1)
            
            
            ZStack {
                Rectangle()
                    .fill(.white)
                Text("map")
            }
            .padding(.top, 110)
            .padding(.bottom, 64)
            .zIndex(0)
            
            // 하단
            VStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                TabScreenComponent()
                    .frame(height: 64)
            }
            .zIndex(1)
            
        }
    }
}

#Preview {
    MainScreen()
}
