//
//  CategoryBox.swift
//  
//
//  Created by 최준영 on 2024/01/13.
//

import SwiftUI
import GlobalObjects

struct CategoryBox: View {
    
    @Binding var selected: Int64?
    
    var object: CategoryObject
    
    private var isSelected: Bool { selected == object.id }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            
            ZStack(alignment: .leading) {
                
                Color.clear
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(object.name)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text(object.description)
                        .font(.system(size: 12))
                        .lineSpacing(5)
                }
                
            }
            
            Spacer(minLength: 0)
            
            TagCases[object.id].getIllust()
                .resizable()
                .scaledToFit()
        }
        .padding(.leading, 24)
        .padding(.trailing, 16)
        .padding(10)
        .background{
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? .mainScreenRed.opacity(0.2) : .btn_light_grey)
                
                if isSelected {
                        
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.red, lineWidth: 1)
                    
                }
                
            }
        }
        .frame(height: 100)
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            selected = object.id
        }
        
    }
    
}
