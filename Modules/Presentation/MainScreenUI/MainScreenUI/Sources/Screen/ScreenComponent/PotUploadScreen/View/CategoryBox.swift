//
//  CategoryBox.swift
//  
//
//  Created by 최준영 on 2024/01/13.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents

struct CategoryBox: View {
    
    @Binding var selected: Int64?
    
    var object: CategoryObject
    
    private var isSelected: Bool { selected == object.id }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(object.name)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(height: 20)
                
                GeometryReader { geo in
                    
                    let descriptions = object.description.split(separator: "\n").map { String($0) }
                    
                    let lineSpacing = 5.0
                    
                    let count = CGFloat(descriptions.count)
                    
                    let height = (geo.size.height-lineSpacing*(count-1)) / count
                    
                    VStack(spacing: lineSpacing) {
                        
                        ForEach(descriptions, id: \.self) {
                            
                            DynamicText(
                                $0,
                                textColor: .black,
                                lineCount: 1
                            )
                            .frame(width: geo.size.width, height: height)
                        }
                    }
                }
            }
            .padding(.leading, 24)
            .padding(.vertical, 18)
            
            TagCases[object.id].getIllust()
                .resizable()
                .scaledToFit()
                .padding(10)
                .padding(.trailing, 16)
        }
        .frame(height: 100)
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
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            selected = object.id
        }
        
    }
    
}
