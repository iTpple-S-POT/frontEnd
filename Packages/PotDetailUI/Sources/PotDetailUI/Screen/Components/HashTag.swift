//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/24/24.
//

import SwiftUI

struct HashTag: View {
    let tags = ["#농구장", "#스포츠", "#야외활동", "#운동", "#팀스포츠"] // 이 배열은 당신의 태그에 따라 달라질 것입니다.
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    TagButton(tagName: tag)
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct TagButton: View {
    var tagName: String
    
    var body: some View {
        Button(action: {
            // 버튼 클릭 시 수행할 동작
        }) {
            Text(tagName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16) // 좌우 패딩
                .padding(.vertical, 8) // 상하 패딩
                .background(
                    Capsule().strokeBorder(Color.white, lineWidth: 1)
                )
        }
        .clipShape(Capsule())
        // frame(width: height:)를 제거하여 SwiftUI가 내용물에 맞게 자동으로 너비를 조정하게 합니다.
    }
}


#Preview {
    HashTag()
}
