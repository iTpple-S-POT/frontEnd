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
            
            // 태그 선택 바
            Rectangle()
                .fill(.orange)
                .frame(height: 64)
            
            // 팟을 표시하는 지도
            ZStack {
                Rectangle()
                    .fill(.white)
                Text("map")
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
