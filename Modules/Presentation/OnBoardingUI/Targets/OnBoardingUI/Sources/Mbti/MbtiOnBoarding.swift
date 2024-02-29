//
//  MbtiOnBoarding.swift
//  OnBoardingUI
//
//  Created by 최준영 on 2/29/24.
//

import SwiftUI
import DefaultExtensions

public struct MbtiOnBoarding: View {
    
    @Binding var present: Bool
    
    public init(present: Binding<Bool>) {
        self._present = present
    }
    
    public var body: some View {
        ZStack {
            
            Color.backgroundColor
                .ignoresSafeArea(.all)
            
            Image.makeImageFromBundle(bundle: .module, name: "mbti_guide", ext: .png)
                .resizable()
                .scaledToFit()
                .overlay {
                    VStack {
                        
                        HStack {
                            
                            Spacer()
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    
                                    present = false
                                }
                                .padding(16)
                        }
                        
                        Spacer()
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .padding(.horizontal, 21)
        }
    }
}
    

#Preview {
    MbtiOnBoarding(present: .constant(true))
}
