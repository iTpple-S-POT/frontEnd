//
//  MainScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI

public struct MainScreen: View {
    
    public init() { }
    
    public var body: some View {
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
                MapScreenComponent()
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
