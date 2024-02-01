//
//  HomeScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI
import GlobalObjects

struct HomeScreen: View {
    
    @EnvironmentObject private var mainScreenModel: MainScreenModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            TopMostScreenComponent()
                .frame(height: 56)
            
            ZStack {
                
                VStack() {
                    
                    SelectMapTagScreenComponent()
                        .frame(height: 88)
                    
                    Spacer()
                    
                }
                .zIndex(1)
                
                MapScreenComponent()
                    .zIndex(0)
            }
        }
    }
}

#Preview {
    MainScreen()
}
