//
//  TagBox.swift
//
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalObjects

struct TagBox: View {
    
    var selectedTag: TagCases
    
    var tag: TagCases
    
    var isSelected: Bool
    
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            
            if tag != .all {
                tag.getIcon(type: isSelected ? .point : .idle)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28)
            }
            
            Text(tag.getKorString())
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isSelected ? .white : .black)
            
        }
        .frame(height: 40)
        .padding(.horizontal, 16)
        .background {
            PerfectRoundedRectangle()
                .fill(isSelected ? tag.getPointColor() : .white)
                .shadow(color: .gray.opacity(0.5), radius: 5)
        }
        .contentShape(PerfectRoundedRectangle())
        .onTapGesture(perform: action)
    }
}

#Preview {
    ZStack {
        
        Color.white
        
        TagBox(selectedTag: .information, tag: .information, isSelected: false) {
            
        }
    }
}
