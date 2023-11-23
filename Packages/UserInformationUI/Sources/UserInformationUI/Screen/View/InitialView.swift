//
//  File.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

struct InitialView: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Text1
            Text("가입을 축하드려요!")
                .font(.suite(type: .SUITE_SemiBold, size: 20))
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
            Rectangle()
                .padding(.top, 55)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        InitialView()
        Spacer(minLength: 0)
    }
}
