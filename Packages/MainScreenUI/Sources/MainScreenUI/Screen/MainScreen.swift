//
//  MainScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            
            TopMostScreenComponent()
                .frame(height: 56)
            
            ZStack {
                VStack {
                    SelectMapTagScreenComponent()
                        .frame(height: 64)
                    Spacer(minLength: 0)
                }
                .zIndex(1.0)

                // 팟을 표시하는 지도
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Text("map")
                }
                .padding(.top, 64)
                .zIndex(0.0)
            }
            
            // 탭뷰
            Rectangle()
                .fill(.green)
                .frame(height: 64)
            
        }
    }
}

#Preview {
    MainScreen()
}
