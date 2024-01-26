//
//  WelcomeScreen.swift
//
//
//  Created by 최준영 on 1/21/24.
//

import SwiftUI
import DefaultExtensions
import GlobalObjects


public struct WelcomeScreen: View {
    
    @EnvironmentObject private var mainNavigation: MainNavigation
    
    public init() { }
    
    public var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea(.container)
            
            VStack(spacing: 10) {
                
                Image.makeImageFromBundle(bundle: .module, name: "welcome_illust", ext: .png)
                    .resizable()
                    .scaledToFit()
                
                
                VStack(spacing: 5) {
                    
                    Text("S:POT 가입을")
                    Text("축하드립니다!")
                    
                }
                .font(.title)
                .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            
        }
        .onAppear(perform: {
            mainNavigation.delayedNavigation(work: .add, destination: .preferenceScreen)
        })
    }
}

#Preview {
    WelcomeScreen()
}
