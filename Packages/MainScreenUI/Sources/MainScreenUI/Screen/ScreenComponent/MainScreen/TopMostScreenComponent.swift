//
//  TopMostScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI
import DefaultExtensions
import PotDetailUI

struct TopMostScreenComponent: View {
    @State private var isShowingSearchScreen = false
    
    var body: some View {
        
        ZStack {
            
            Color.mainScreenRed
            
            HStack(spacing: 0) {
                Image.makeImageFromBundle(bundle: Bundle.module,name: ImageName.main_screen_title, ext: .png)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                Spacer(minLength: 0)
                
                Button {
                    isShowingSearchScreen = true
                } label: {
                    Image.makeImageFromBundle(bundle: Bundle.module, name: ImageName.search, ext: .png)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .fullScreenCover(isPresented: $isShowingSearchScreen, content: {
                    SearchScreen()
                })
                
            }
            .padding(.horizontal, 16)
            
        }
    }
}

#Preview {
    TopMostScreenComponent()
        .frame(height: 56)
}
