//
//  SelectMapTagScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalFonts
import GlobalObjects

struct SelectMapTagScreenComponent: View {
       
    @EnvironmentObject var mainScreenModel: MainScreenModel
    
    var body: some View {
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal) {
                
                LazyHStack(spacing: 12) {
                    
                    ForEach(TagCases.allCases) { tag in
                        
                        TagBox(selectedTag: mainScreenModel.selectedTag, tag: tag, isSelected: mainScreenModel.checkSelected(tag), action: {
                            
                            mainScreenModel.selectTag(tag: tag)
                            
                        })
                        .id(tag)
                    
                    }
                    
                }
                .padding(.leading, 21)
            }
            .scrollIndicators(.hidden)
            .onChange(of: mainScreenModel.selectedTag) { tag in
                withAnimation(.easeInOut(duration: 0.5)) {
                    proxy.scrollTo(tag, anchor: .center)
                }
            }
        }
    }
}

#Preview {
    SelectMapTagScreenComponent()
        .frame(height: 64)
        .environmentObject(MainScreenModel())
}
