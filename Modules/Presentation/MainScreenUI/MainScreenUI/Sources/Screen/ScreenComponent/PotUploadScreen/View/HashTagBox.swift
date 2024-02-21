//
//  HashTagBox.swift
//
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI
import GlobalUIComponents

struct HashTagBox: View {
    var name: String
    var dismissAction: () -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            
            Text("#\(name)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.regular_gray)
            
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .padding(3)
                .frame(width: 16)
                .foregroundStyle(.regular_gray)
                .onTapGesture(perform: dismissAction)
            
        }
        .frame(height: 40)
        .padding(.horizontal, 12)
        .background(
            PerfectRoundedRectangle()
                .fill(.btn_light_grey)
        )
    }
}

#Preview {
    HashTagBox(name: "안녕하세요") {
        
    }
}
