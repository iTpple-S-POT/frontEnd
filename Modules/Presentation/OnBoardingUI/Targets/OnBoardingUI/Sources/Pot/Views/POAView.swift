//
//  POAView.swift
//  OnBoardingUI
//
//  Created by 최준영 on 2/29/24.
//

import SwiftUI
import DefaultExtensions

struct POAImage: View {

    var body: some View {
        
        Image(uiImage: ImageRenderer(content: POAView()).uiImage!)
            .resizable()
            .scaledToFit()
    }
}

struct POBImage: View {

    var body: some View {
        
        Image(uiImage: ImageRenderer(content: POBView()).uiImage!)
            .resizable()
            .scaledToFit()
    }
}

struct POCImage: View {

    var body: some View {
        
        Image(uiImage: ImageRenderer(content: POCView()).uiImage!)
            .resizable()
            .scaledToFit()
    }
}

struct POAView: View {
    var body: some View {
        ZStack {
            
            Image.makeImageFromBundle(bundle: .module, name: "pot_onboardingA2", ext: .png)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 16)
            
            VStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 212, height: 255)
                    .shadow(radius: 3)
                    .overlay {
                        VStack {
                            Image.makeImageFromBundle(bundle: .module, name: "pot_onboardingA1", ext: .png)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 15)
                                .padding(.top, 12)
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 112)
                
                Spacer()
                
            }
            
        }
        .frame(width: 212, height: 390)
    }
}

struct POBView: View {
    var body: some View {
        ZStack {
            
            Image.makeImageFromBundle(bundle: .module, name: "pot_onboardingB2", ext: .png)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 16)
            
            VStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 212, height: 255)
                    .shadow(radius: 3)
                    .overlay {
                        VStack {
                            Image.makeImageFromBundle(bundle: .module, name: "pot_onboardingB1", ext: .png)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 15)
                                .padding(.top, 12)
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 73)
                
                Spacer()
                
            }
            
        }
        .frame(width: 212, height: 390)
    }
}

struct POCView: View {
    var body: some View {
        ZStack {
            
            Image.makeImageFromBundle(bundle: .module, name: "pot_onboardingC", ext: .png)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 16)
            
        }
        .frame(width: 212, height: 390)
    }
}

#Preview {
    POCView()
}
