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
//    @State private var isShowingSearchScreen = false
    
    var body: some View {
        
        ZStack {
            
            Color.mainScreenRed
                .ignoresSafeArea(.all, edges: .top)
            
            HStack(spacing: 0) {
                Image.makeImageFromBundle(bundle: Bundle.module,name: "spot_logo_image", ext: .png)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 56)
                
                Spacer(minLength: 0)
                
//                Button {
//                    isShowingSearchScreen = true
//                } label: {
//                    Image.makeImageFromBundle(bundle: Bundle.module, name: "main_bell", ext: .png)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 32)
//                }
//                .fullScreenCover(isPresented: $isShowingSearchScreen, content: {
//                    SearchScreen()
//                })
                
            }
            .padding(.horizontal, 21)
            
        }
        .frame(height: 56)
        .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
    }
}

#Preview {
    VStack {
        TopMostScreenComponent()
            .frame(height: 56)
        
        Spacer()
    }
    
}
