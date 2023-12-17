//
//  File.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

struct StartConfigurationScreenComponent: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Text1
            Text("시작하기 전")
                .font(.suite(type: .SUITE_SemiBold, size: 28))
                .frame(height: 36)
                .padding(.top, 68)
            
            // Text2
            VStack {
                (
                    Text("나만의 프로필")
                        .font(.suite(type: .SUITE_SemiBold, size: 32))
                    +
                    Text("을")
                        .font(.suite(type: .SUITE_Regular, size: 32))
                )
                Text("만들어 보세요 :)")
                    .font(.suite(type: .SUITE_Regular, size: 32 ))
            }
            .frame(height: 96)
            
            // TODO: illust
            Image.makeImageFromBundle(name: "StartConfigureScreenILLust", ext: .png)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 22)
                .padding(.top, 55)
            
            Spacer(minLength: 0)
            
        }
        .padding(.bottom, 148)
    }
}

#Preview {
    VStack(spacing: 0) {
        StartConfigurationScreenComponent()
        Spacer(minLength: 0)
    }
}
